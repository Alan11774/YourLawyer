package mx.com.yourlawyer.yourlawyer.view

import alertDialog
import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Spinner
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import loadImage
import message
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.controller.UserViewModel
import mx.com.yourlawyer.yourlawyer.databinding.FragmentPostCaseBinding
import mx.com.yourlawyer.yourlawyer.model.CaseDetails
import saveUri
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

class PostCaseFragment : Fragment() {
    private var _binding: FragmentPostCaseBinding? = null
    private val binding get() = _binding!!

    private val auth = FirebaseAuth.getInstance()
    private val db = FirebaseFirestore.getInstance()
    private val email = auth.currentUser?.email
    private var postedDate:String? = null

    private val PICK_IMAGE_REQUEST = 1
    private var selectedImageUri: Uri? = Uri.EMPTY

    private var categorySelectedOption : String = ""
    private var requirements1SelectedOption : String = ""
    private var requirements2SelectedOption : String = ""
    private var tag1SelectedOption : String = ""
    private var tag2lectedOption : String = ""
    private var tag3SelectedOption : String = ""

    private val userViewModel by lazy {
        ViewModelProvider(requireActivity())[UserViewModel::class.java] }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        _binding = FragmentPostCaseBinding.inflate(inflater, container, false)
        setupUI()
        return binding.root
    }

    private fun setupUI() {
        val calendar = Calendar.getInstance()
        val dateFormat = SimpleDateFormat("HH:mm:ss", Locale.getDefault())
        postedDate = dateFormat.format(calendar.time)
        binding.postedByLabel.text = "Publicado por : ${email} el dia ${postedDate}"

        binding.caseImageView.setImageResource(R.drawable.empty_image_resource)

       setupSpinners()

        binding.publishButton.setOnClickListener { verifyFields() }
        binding.uploadImageButton.setOnClickListener {
            val intent = Intent(Intent.ACTION_PICK)
            intent.type = "image/*"
            startActivityForResult(intent, PICK_IMAGE_REQUEST)
        }

    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == PICK_IMAGE_REQUEST && resultCode == Activity.RESULT_OK) {
            data?.data?.let { imageUri ->
                // Load the image using Glide
                loadImage(imageUri, binding.caseImageView, binding.root.context, R.drawable.person_resource)
                selectedImageUri = imageUri

            }
        }
    }

    private fun verifyFields(){


        binding.apply {
            val title = titleEditText.text.toString()
            val description = descriptionEditText.text.toString()
            val location = caseLocationLabel.text.toString()
            val budget = budgetLabel.text.toString()
            val postedBy ="Publicado por : ${email} el dia ${postedDate}"
            val urgency = urgency.text.toString()


            val variable = listOf(
                title, description, location,
                budget, postedBy, urgency, categorySelectedOption,
                requirements1SelectedOption, requirements2SelectedOption,
                tag1SelectedOption, tag2lectedOption, tag3SelectedOption
            )
            val allFieldsFilled = variable.all { it.isNotBlank() }
            if (allFieldsFilled and (selectedImageUri != Uri.EMPTY)){
                publishInfo(list = variable)


            }else{
                message(getString(R.string.llena_todos_los_campos))
                alertDialog(
                    binding.root.context,
                    getString(R.string.error), getString(R.string.por_favor_a_ade_una_imagen_y_llena_todos_los_campos),
                    "Ok",
                    onPositiveButtonClick = {

                    }
                )

            }
        }

    }

    private fun publishInfo(list: List<String>){
            if (email.isNullOrEmpty()) {
                message("No se encontró el usuario autenticado")
                return
            }

            // Datos a actualizar
            val updatedData = hashMapOf<String, Any?>(
                "caseId" to "Case999",
                "imageURL" to selectedImageUri,
                "title" to binding.titleEditText.text.toString(),
                "description" to binding.descriptionEditText.text.toString(),
                "category" to categorySelectedOption,
                "postedBy" to email,
                "postedDate" to postedDate,
                "budget" to binding.budgetLabel.text.toString(),
                "location" to binding.caseLocationLabel.text.toString(),
                "status" to binding.urgency.text.toString(),
                "details" to CaseDetails(
                    tags = listOf(tag1SelectedOption, tag2lectedOption, tag3SelectedOption),
                    requirements = listOf(requirements1SelectedOption, requirements2SelectedOption),
                    urgency = binding.urgency.text.toString()
                )

            ).filterValues { it != null } // Eliminar valores nulos

            // Referencia al documento del perfil
            val profileDocRef = db.collection("users")
                .document(email)
                .collection("postedCases").document()
            profileDocRef.get()
                .addOnSuccessListener { document ->
                    if (document.exists()) {
                        // Si el documento ya existe, actualiza los datos
                        profileDocRef.update(updatedData)
                            .addOnSuccessListener {


                                alertDialog(binding.root.context,
                                    getString(R.string.actualizaci_n_exitosa),
                                    getString(R.string.se_ha_actualizado_tu_caso),
                                    "Ok",
                                    onPositiveButtonClick = {
                                        requireActivity().supportFragmentManager.popBackStack()
                                    }
                                )
                            }
                            .addOnFailureListener { e ->
                                alertDialog(
                                    binding.root.context,
                                    getString(R.string.error),
                                    getString(R.string.error_al_postear_el_caso_revisa_tu_conexion_a_internet_o_intentalo_mas_tarde),
                                    "Ok",
                                    onPositiveButtonClick = {
                                    }
                                )
                            }
                    } else {
                        // Si el documento no existe, crea uno nuevo
                        profileDocRef.set(updatedData)
                            .addOnSuccessListener {
                                alertDialog(binding.root.context,
                                    getString(R.string.publicaci_n_exitosa),
                                    getString(R.string.se_ha_publicado_tu_caso),
                                    "Ok",
                                    onPositiveButtonClick = {
                                        requireActivity().supportFragmentManager.popBackStack()
                                    }
                                )
                            }
                            .addOnFailureListener { e ->
                                alertDialog(
                                    binding.root.context,
                                    getString(R.string.error),
                                    getString(R.string.error_al_postear_el_caso_revisa_tu_conexion_a_internet_o_intentalo_mas_tarde),
                                    "Ok",
                                    onPositiveButtonClick = {
                                    }
                                )
                            }
                    }
                }
                .addOnFailureListener { e ->
                    message(getString(R.string.error_al_verificar_el_perfil, e.message))
                }

    }

    private fun setupSpinners(){
        SpinnerUtils.setupSpinner(
            binding.root.context,
            binding.mySpinner,
            R.array.law_categories
        ){ selectedOption ->
            if (!selectedOption.contains(getString(R.string.selecciona))){
                categorySelectedOption = selectedOption
            }
        }

        SpinnerUtils.setupSpinner(
            binding.root.context,
            binding.spinnerRequirements1,
            R.array.requerimientos_cliente
        ){ selectedOption ->
            if (!selectedOption.contains(getString(R.string.selecciona))){
                requirements1SelectedOption = selectedOption
            }
        }
        SpinnerUtils.setupSpinner(
            binding.root.context,
            binding.spinnerRequirements2,
            R.array.requerimientos_cliente
        ){ selectedOption ->
            if (!selectedOption.contains(getString(R.string.selecciona))){
                requirements2SelectedOption = selectedOption
            }
        }
        SpinnerUtils.setupSpinner(
            binding.root.context,
            binding.spinnerTag1,
            R.array.tag_categories
        ){ selectedOption ->
            if (!selectedOption.contains(getString(R.string.selecciona))){
                tag1SelectedOption = selectedOption
            }
        }
        SpinnerUtils.setupSpinner(
            binding.root.context,
            binding.spinnerTag2,
            R.array.tag_categories
        ){ selectedOption ->
            if (!selectedOption.contains(getString(R.string.selecciona))){
                tag2lectedOption = selectedOption
            }
        }
        SpinnerUtils.setupSpinner(
            binding.root.context,
            binding.spinnerTag3,
            R.array.tag_categories
        ){ selectedOption ->
            if (!selectedOption.contains(getString(R.string.selecciona))){
                tag3SelectedOption = selectedOption
            }
        }

    }


}