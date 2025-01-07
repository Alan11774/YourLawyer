import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.core.content.ContextCompat.getSystemService
import androidx.fragment.app.Fragment
import androidx.navigation.NavController
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.firebase.auth.FirebaseAuth
import mx.com.yourlawyer.yourlawyer.ProfileFragment
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.databinding.FragmentCasesBinding
import mx.com.yourlawyer.yourlawyer.model.CasesResponse
import mx.com.yourlawyer.yourlawyer.model.ClientRetrofit
import mx.com.yourlawyer.yourlawyer.view.MainActivity
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class CasesFragment : Fragment() {

    private var _binding: FragmentCasesBinding? = null
    private val binding get() = _binding!!
    private lateinit var navController: NavController

    private lateinit var adapter: CasesAdapter

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        // Inflar el layout usando View Binding
        _binding = FragmentCasesBinding.inflate(inflater, container, false)

        adapter = CasesAdapter(emptyList()) // Lista inicial vacía
        binding.tableView.layoutManager = LinearLayoutManager(requireContext())
        binding.tableView.adapter = adapter

        // Configurar RecyclerView
        binding.tableView.layoutManager = LinearLayoutManager(requireContext())

        // Llamar a la API
        fetchCases()


        binding.logoutButton.setOnClickListener {
            showLogoutConfirmationDialog()
        }
        binding.userProfileImageView.setOnClickListener{
            showProfile()
        }

        return binding.root
    }

    private fun fetchCases() {
        val api = ClientRetrofit.instance

        api.getCases().enqueue(object : Callback<CasesResponse> {
            override fun onResponse(call: Call<CasesResponse>, response: Response<CasesResponse>) {
                if (response.isSuccessful) {
                    val cases = response.body()?.cases ?: emptyList()
                    val adapter = CasesAdapter(cases)
                    binding.tableView.adapter = adapter
                } else {
                    Toast.makeText(requireContext(), "Error: ${response.message()}", Toast.LENGTH_SHORT).show()
                }
            }

            override fun onFailure(call: Call<CasesResponse>, t: Throwable) {
                Toast.makeText(requireContext(), "Falla al cargar los datos: ${t.message}", Toast.LENGTH_SHORT).show()
            }
        })
    }

    private fun showLogoutConfirmationDialog() {
        // Crear el AlertDialog
        val builder = AlertDialog.Builder(requireContext())
        builder.setTitle("Cerrar sesión")
        builder.setMessage("¿Estás seguro de que deseas salir de la sesión actual?")

        // Botón "Sí"
        builder.setPositiveButton("Sí") { _, _ ->
            logout() // Llamar al método de logout
        }

        // Botón "No"
        builder.setNegativeButton("No") { dialog, _ ->
            dialog.dismiss() // Cerrar el popup sin hacer nada
        }

        // Mostrar el diálogo
        val dialog = builder.create()
        dialog.show()
    }

    private fun logout() {
        FirebaseAuth.getInstance().signOut()
        message( "Sesión cerrada")

        // Redirige al usuario a la pantalla de inicio de sesión
        val intent = Intent(requireContext(), MainActivity::class.java)
        startActivity(intent)
        requireActivity().finish()

    }

    private fun showProfile(){
            findNavController().navigate(R.id.action_casesFragment_to_profileFragment)

    }
    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}