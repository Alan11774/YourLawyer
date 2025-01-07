import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import mx.com.yourlawyer.yourlawyer.databinding.FragmentAllLawyersBinding
import mx.com.yourlawyer.yourlawyer.model.ClientRetrofit
import mx.com.yourlawyer.yourlawyer.model.LawyersResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import message
import mx.com.yourlawyer.yourlawyer.R

class AllLawyersFragment : Fragment() {

    private var _binding: FragmentAllLawyersBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentAllLawyersBinding.inflate(inflater, container, false)

        // Configurar RecyclerView
        binding.tableView.layoutManager = LinearLayoutManager(requireContext())

        // Llamar a la API
        fetchLawyers()

        return binding.root
    }

    private fun fetchLawyers() {
        val api = ClientRetrofit.instance

        api.getLawyers().enqueue(object : Callback<LawyersResponse> {
            override fun onResponse(call: Call<LawyersResponse>, response: Response<LawyersResponse>) {
                if (response.isSuccessful) {
                    val lawyers = response.body()?.lawyers ?: emptyList()
                    val adapter = LawyersAdapter(lawyers)
                    binding.tableView.adapter = adapter
                } else {
                    message(getString(R.string.Error, response.message()))
                    //Toast.makeText(requireContext(), "Error: ${response.message()}", Toast.LENGTH_SHORT).show()

                }
            }

            override fun onFailure(call: Call<LawyersResponse>, t: Throwable) {
                message(getString(R.string.falla_al_cargar_los_datos, t.message))
                //Toast.makeText(requireContext(), "Falla al cargar los datos: ${t.message}", Toast.LENGTH_SHORT).show()
            }
        })
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}