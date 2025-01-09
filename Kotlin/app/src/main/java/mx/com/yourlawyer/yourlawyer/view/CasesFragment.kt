import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.core.net.toUri
import androidx.fragment.app.Fragment
import androidx.navigation.NavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.bumptech.glide.Glide
import com.bumptech.glide.load.resource.bitmap.RoundedCorners
import com.google.firebase.auth.FirebaseAuth
import mx.com.yourlawyer.yourlawyer.view.ProfileFragment
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.databinding.FragmentCasesBinding
import mx.com.yourlawyer.yourlawyer.model.Case
import mx.com.yourlawyer.yourlawyer.model.CasesResponse
import mx.com.yourlawyer.yourlawyer.model.ClientRetrofit
import mx.com.yourlawyer.yourlawyer.model.ProfileManager
import mx.com.yourlawyer.yourlawyer.view.DetailCaseFragment
import mx.com.yourlawyer.yourlawyer.view.MainActivity
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class CasesFragment : Fragment() {

    private var _binding: FragmentCasesBinding? = null
    private val binding get() = _binding!!

    private lateinit var adapter: CasesAdapter
    // Singleton
    private val currentProfile = ProfileManager.getProfile()
    private  var sendUriString:String = ""

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        // Inflar el layout usando View Binding
        _binding = FragmentCasesBinding.inflate(inflater, container, false)


        adapter = CasesAdapter(emptyList()) { selectedCase ->
            openCaseDetails(selectedCase)
        }
//        adapter = CasesAdapter(emptyList()) // Lista inicial vacía
        binding.tableView.layoutManager = LinearLayoutManager(requireContext())
        binding.tableView.adapter = adapter


        // Llamar a la API
        fetchCases()

        actions()

        return binding.root
    }
    private fun fetchCases() {
        val api = ClientRetrofit.instance

        api.getCases().enqueue(object : Callback<CasesResponse> {
            override fun onResponse(call: Call<CasesResponse>, response: Response<CasesResponse>) {
                if (response.isSuccessful) {
                    val cases = response.body()?.cases ?: emptyList()
                    adapter = CasesAdapter(cases) { selectedCase ->
                        openCaseDetails(selectedCase)
                    }
                    binding.tableView.adapter = adapter
                } else {
                    message("Error: ${response.message()}")
                }
            }

            override fun onFailure(call: Call<CasesResponse>, t: Throwable) {
                message("Falla al cargar los datos: ${t.message}")
            }
        })
    }

    private fun openCaseDetails(case: Case) {
        val nextFragment = DetailCaseFragment()
        val bundle = Bundle().apply {
            putString("caseId", case.caseId)
            putString("caseImageUrl", case.imageURL)
            putString("caseTitle", case.title)
            putString("caseDescription", case.description)
            putString("category", case.category)
            putString("casePostedBy", case.postedBy)
            putString("casePostedDate", case.postedDate)
            putString("caseBudget", case.budget)
            putString("caseLocation", case.location)
            putString("caseStatus", case.status)
            //putString("tags",case.details.tags.toString())
            putStringArrayList("tags",ArrayList(case.details.tags))
            //putString("requirements",case.details.requirements.toString())
            putStringArrayList("requirements",ArrayList(case.details.requirements))
            putString("urgency",case.details.urgency)
        }
        nextFragment.arguments = bundle

        requireActivity().supportFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, nextFragment)
            .addToBackStack(null)
            .commit()
    }

    private fun actions(){
        val imageUriString = arguments?.getString("imageUri")
        imageUriString?.let { uriString ->
            val imageUri = Uri.parse(uriString)
            sendUriString = imageUriString
            Glide.with(binding.root.context)
                .load(imageUri)
                .circleCrop()
                .error(R.drawable.person_resource)
                .into(binding.userProfileImageView)
        }

        binding.logoutButton.setOnClickListener {
            showLogoutConfirmationDialog()
        }
        binding.userProfileImageView.setOnClickListener{
            showProfile()
        }

    }

    private fun showLogoutConfirmationDialog() {
        // Crear el AlertDialog para salior de sesion
        val builder = AlertDialog.Builder(requireContext())
        builder.setTitle("Cerrar sesión")
        builder.setMessage("¿Estás seguro de que deseas salir de la sesión actual?")

        builder.setPositiveButton("Sí") { _, _ ->
            logout()
        }
        builder.setNegativeButton("No") { dialog, _ ->
            dialog.dismiss() // Cerrar el popup sin hacer nada
        }
        val dialog = builder.create()
        dialog.show()
    }

    private fun logout() {
        FirebaseAuth.getInstance().signOut()
        message( "Sesión cerrada")

        // Redirige al usuario a la pantalla de inicio de sesión esta fiue hecha con el MainActivity
        val intent = Intent(requireContext(), MainActivity::class.java)
        startActivity(intent)
        requireActivity().finish()

    }

    private fun showProfile(){
        val nextFragment = ProfileFragment()
        val bundle = Bundle()
        bundle.putString("imageUri", sendUriString)
        nextFragment.arguments = bundle
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