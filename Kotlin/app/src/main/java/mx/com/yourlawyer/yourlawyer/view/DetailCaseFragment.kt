package mx.com.yourlawyer.yourlawyer.view


import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.fragment.app.Fragment
import com.bumptech.glide.Glide
import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.firestore
import loadImage
import message
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.databinding.FragmentDetailCaseBinding
import mx.com.yourlawyer.yourlawyer.databinding.FragmentProfileBinding

class DetailCaseFragment : Fragment() {

//    private var lawyer: Lawyer? = null


    private var _binding: FragmentDetailCaseBinding? = null
    private val binding get() = _binding!!

    private val auth = FirebaseAuth.getInstance()
    private val db = FirebaseFirestore.getInstance()
    private var casePurchasing = ""



    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentDetailCaseBinding.inflate(inflater, container, false)
        setupUI()
        getCaseStatus()
        // Configurar listeners para los botones
        binding.cancelButton.setOnClickListener { cancelAction() }
        binding.applyButton.setOnClickListener { contractAction() }
        binding.submitApplyButton.setOnClickListener { submitApplyAction() }

        return binding.root
    }

    @SuppressLint("SetTextI18n")
    private fun setupUI() {
        val imUri = arguments?.getString("caseImageUrl")
        if (imUri != null) {
            loadImage(imUri, binding.caseImageView, binding.root.context,
                R.drawable.legal)
        }

        binding.apply {
            titleLabel.text = arguments?.getString("caseTitle")
            categoryLabel.text = arguments?.getString("category")
            descriptionLabel.text = arguments?.getString("caseDescription")
            caseLocationLabel.text = arguments?.getString("caseLocation")
            budgetLabel.text = arguments?.getString("caseBudget")
            postedByLabel.text = arguments?.getString("casePostedBy")
            urgency.text = arguments?.getString("caseStatus")
            requirements1.text = arguments?.getStringArrayList("requirements")?.first() ?: ""
            requirements2.text = arguments?.getStringArrayList("requirements")?.get(1) ?: ""
            tag1.text = arguments?.getStringArrayList("tags")?.first() ?: ""
            tag2.text = arguments?.getStringArrayList("tags")?.get(1) ?: ""
            tag3.text = arguments?.getStringArrayList("tags")?.last() ?: ""
            budgetRangeLabel.text = "Budget Range: ${binding.budgetLabel.text}"
        }
    }

    private fun cancelAction() {
        binding.apply {
            linerLayoutDescription.visibility = View.VISIBLE
            proposalLinearLayout.visibility = View.GONE
        }

    }

    private fun contractAction() {
    binding.apply {
        linerLayoutDescription.visibility = View.GONE
        proposalLinearLayout.visibility = View.VISIBLE
    }

    }
    private fun submitApplyAction() {
        try {
            val value = binding.budgetEditText.text.toString()
            val range = binding.budgetLabel.text.toString()
            val rangeList = range.split(" ", "-", "MXN").filter { it.trim().isNotEmpty() }.map { it.toInt() }
            val min = rangeList[0].toDouble()
            val max = rangeList[1].toDouble()
            if (value.isEmpty()) {
                message(getString(R.string.por_favor_ingresa_un_presupuesto_para_aplicar_a_este_proyecto))
                return
                }else{
                    if (value.toDouble() in min..max) {
                        message(getString(R.string.contrataci_n_publicadaa))
                        casePurchasing = "Waiting Approval"
                        postInFirebase()
                        binding.linerLayoutDescription.visibility = View.VISIBLE
                        binding.proposalLinearLayout.visibility = View.GONE
                        binding.applyButton.visibility = View.GONE
                        binding.apply {
                            linerLayoutDescription.visibility = View.VISIBLE
                            proposalLinearLayout.visibility = View.GONE

                            submitApplyButton.visibility = View.GONE

                            finalBudgetProposalTextView.visibility = View.VISIBLE
                            finalBudgetProposalTextView.text = getString(
                                R.string.esperando_confirmaci_n_del_cliente_presupuesto_ofertado,
                                value
                            )

                        }

                    }else{
                        message(getString(R.string.ingresa_un_presupuesto_en_rango))
                        return
                    }
                }
            }catch ( e: Exception){
                message(getString(R.string.ingresa_un_presupuesto_valido))
                return
            }

    }

    private fun postInFirebase(){

        val userEmail = auth.currentUser?.email
        if (userEmail.isNullOrEmpty()) {
            message("No se encontró el usuario autenticado")
            return
        }

        // Datos a actualizar
        val updatedData = hashMapOf<String, Any?>(
            "budget" to binding.finalBudgetProposalTextView.text.toString(),
            "title" to binding.titleLabel.text.toString(),
            "caseDescription" to binding.descriptionLabel.text.toString(),
            "requirements" to listOf(binding.requirements1.text.toString(), binding.requirements2.text.toString()),
            "tags" to listOf(binding.tag1.text.toString(), binding.tag2.text.toString(), binding.tag3.text.toString()),
            "status" to casePurchasing,
            "clientEmail" to binding.postedByLabel.text.toString(),
            "lawyerEmail" to userEmail
        ).filterValues { it != null } // Eliminar valores nulos

        // Referencia al documento del perfil
        val profileDocRef = db.collection("users")
            .document(userEmail)
            .collection("profile")
            .document("cases")

        profileDocRef.get()
            .addOnSuccessListener { document ->
                if (document.exists()) {
                    // Si el documento ya existe, actualiza los datos
                    profileDocRef.update(updatedData)
                        .addOnSuccessListener {
                            message("Perfil actualizado exitosamente")
                        }
                        .addOnFailureListener { e ->
                            message("Error al actualizar el perfil: ${e.message}")
                        }
                } else {
                    // Si el documento no existe, crea uno nuevo
                    profileDocRef.set(updatedData)
                        .addOnSuccessListener {
                            message("Perfil creado exitosamente")
                        }
                        .addOnFailureListener { e ->
                            message("Error al crear el perfil: ${e.message}")
                        }
                }
            }
            .addOnFailureListener { e ->
                message("Error al verificar el perfil: ${e.message}")
            }
    }
    private fun getCaseStatus(){
        val userEmail = auth.currentUser?.email
        if (userEmail.isNullOrEmpty()) {
            message("No se encontró el usuario autenticado")
            return
        }

        // Referencia al documento del perfil
        val profileDocRef = db.collection("users")
            .document(userEmail)
            .collection("profile")
            .document("cases")

        profileDocRef.get()
            .addOnSuccessListener { document ->
                if (document.exists()) {
                    casePurchasing = document.getString("status").toString()
                    val clientEmail = document.getString("clientEmail")
                    if (casePurchasing == "Accepted" && clientEmail == binding.postedByLabel.text.toString()){
                        binding.finalBudgetProposalTextView.visibility = View.VISIBLE
                        binding.finalBudgetProposalTextView.text = getString(R.string.presupuesto_aceptado)
                        binding.applyButton.visibility = View.GONE
                        binding.submitApplyButton.visibility = View.GONE
                    }
                }
            }
        }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

}