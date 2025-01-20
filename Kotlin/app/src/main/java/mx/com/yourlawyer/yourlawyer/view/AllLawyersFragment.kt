
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.bumptech.glide.Glide
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.controller.UserViewModel
import mx.com.yourlawyer.yourlawyer.databinding.FragmentAllLawyersBinding
import mx.com.yourlawyer.yourlawyer.model.Case
import mx.com.yourlawyer.yourlawyer.model.Lawyer
import mx.com.yourlawyer.yourlawyer.model.ClientRetrofit
import mx.com.yourlawyer.yourlawyer.model.CasesResponse
import mx.com.yourlawyer.yourlawyer.model.LawyersResponse
import mx.com.yourlawyer.yourlawyer.view.DetailCaseFragment
import mx.com.yourlawyer.yourlawyer.view.DetailLawyerFragment
import mx.com.yourlawyer.yourlawyer.view.MainActivity
import mx.com.yourlawyer.yourlawyer.view.PostCaseFragment
import mx.com.yourlawyer.yourlawyer.view.ProfileFragment
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class AllLawyersFragment : Fragment() {

    private var _binding: FragmentAllLawyersBinding? = null
    private val binding get() = _binding!!

    private var sendUriString: String = ""
    private lateinit var adapter: UnifiedAdapter
    private val db = FirebaseFirestore.getInstance()

    private var unifiedItems: List<UnifiedItem> = emptyList()
    private var filteredItems: MutableList<UnifiedItem> = mutableListOf()

    private val userViewModel by lazy {
        ViewModelProvider(requireActivity())[UserViewModel::class.java] }


    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentAllLawyersBinding.inflate(inflater, container, false)

        binding.tableView.layoutManager = LinearLayoutManager(requireContext())

        determineUserRoleAndFetchData()
        actions()

        return binding.root
    }

    private fun determineUserRoleAndFetchData() {
        val email = FirebaseAuth.getInstance().currentUser?.email
        userViewModel.userProfile.observe(viewLifecycleOwner) { userProfile ->
            if (userProfile.userRole == "Cliente" ){
                fetchLawyers()
            } else {
                fetchCases()
            }

        }

    }

    private fun fetchLawyers() {
        val api = ClientRetrofit.instance

        api.getLawyers().enqueue(object : Callback<LawyersResponse> {
            override fun onResponse(call: Call<LawyersResponse>, response: Response<LawyersResponse>) {
                if (response.isSuccessful) {
                    val lawyers = response.body()?.lawyers ?: emptyList()
                    unifiedItems = lawyers.map { UnifiedItem.LawyerItem(it) }
                    setupUnifiedAdapter(unifiedItems)
                } else {
                    message(getString(R.string.Error, response.message()))
                }
            }

            override fun onFailure(call: Call<LawyersResponse>, t: Throwable) {
                message(getString(R.string.falla_al_cargar_los_datos, t.message))
            }
        })
    }

    private fun fetchCases() {
        val api = ClientRetrofit.instance

        api.getCases().enqueue(object : Callback<CasesResponse> {
            override fun onResponse(call: Call<CasesResponse>, response: Response<CasesResponse>) {
                if (response.isSuccessful) {
                    val cases = response.body()?.cases ?: emptyList()
                    unifiedItems = cases.map { UnifiedItem.CaseItem(it) }
                    setupUnifiedAdapter(unifiedItems)
                } else {
                    message("Error: ${response.message()}")
                }
            }

            override fun onFailure(call: Call<CasesResponse>, t: Throwable) {
                message("Falla al cargar los datos: ${t.message}")
            }
        })
    }

    private fun setupUnifiedAdapter(items: List<UnifiedItem>) {
        adapter = UnifiedAdapter(
            items,
            onCaseClick = { case -> openCaseDetails(case) },
            onLawyerClick = { lawyer -> openLawyerDetails(lawyer) }
        )
        binding.tableView.adapter = adapter
    }

    private fun openLawyerDetails(lawyer: Lawyer) {
        // Lógica para abrir detalles del abogado
        userViewModel.setLawyerProfile(lawyer)

        requireActivity().supportFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, DetailLawyerFragment())
            .addToBackStack(null)
            .commit()

    }

    private fun openCaseDetails(case: Case) {
        userViewModel.setCaseProfile(case)
        val nextFragment = DetailCaseFragment()
        val bundle = Bundle().apply {
            putString("caseId", case.caseId)
            putString("caseImageUrl", case.imageURL)
        }
        nextFragment.arguments = bundle

        requireActivity().supportFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, nextFragment)
            .addToBackStack(null)
            .commit()
    }

    private fun filterResults(query: String) {
        filteredItems = unifiedItems.filter {
            when (it) {
                is UnifiedItem.LawyerItem -> it.lawyer.name.contains(query, ignoreCase = true)
                is UnifiedItem.CaseItem -> it.case.title.contains(query, ignoreCase = true)
                else -> {false}
            }
        }.toMutableList()
        setupUnifiedAdapter(filteredItems)
    }
    private fun actions() {
        val imageUriString = getUri(binding.root.context)
        if (imageUriString != null) {
            loadImage(imageUriString, binding.userProfileImageView, binding.root.context, R.drawable.person_resource)
        }
        binding.searchButton.setOnClickListener {
                val searchText = binding.searchTextField.text.toString()
                filterResults(searchText)
        }
        binding.logoutButton.setOnClickListener {
            showLogoutConfirmationDialog()
        }
        binding.addCaseButton.setOnClickListener {
            addCase()
        }
        binding.userProfileImageView.setOnClickListener {
            showProfile()
        }
    }

    private fun showLogoutConfirmationDialog() {
        val builder = AlertDialog.Builder(requireContext())
        builder.setTitle("Cerrar sesión")
        builder.setMessage("¿Estás seguro de que deseas salir de la sesión actual?")

        builder.setPositiveButton("Sí") { _, _ ->
            logout()
        }
        builder.setNegativeButton("No") { dialog, _ ->
            dialog.dismiss()
        }
        val dialog = builder.create()
        dialog.show()
    }

    private fun logout() {
        FirebaseAuth.getInstance().signOut()
        message("Sesión cerrada")

        val intent = Intent(requireContext(), MainActivity::class.java)
        startActivity(intent)
        requireActivity().finish()
    }

    private fun showProfile() {
        val nextFragment = ProfileFragment()
        val bundle = Bundle()
        bundle.putString("imageUri", sendUriString)
        nextFragment.arguments = bundle
        requireActivity().supportFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, nextFragment)
            .addToBackStack(null)
            .commit()
    }
    private fun addCase() {
        val nextFragment = PostCaseFragment()
        requireActivity().supportFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, nextFragment)
            .addToBackStack(null)
            .commit()
    }


    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}