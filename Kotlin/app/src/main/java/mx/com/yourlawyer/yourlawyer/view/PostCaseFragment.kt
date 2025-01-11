package mx.com.yourlawyer.yourlawyer.view

import alertDialog
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
import message
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.controller.UserViewModel
import mx.com.yourlawyer.yourlawyer.databinding.FragmentPostCaseBinding
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
        val postedDate = dateFormat.format(calendar.time)
        binding.postedByLabel.text = "Publicado por : ${email} el dia ${postedDate}"
        binding.caseImageView.setImageResource(R.drawable.empty_image_resource)


       setupSpinners()

        binding.publishButton.setOnClickListener {
            verifyFields()
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
            if (allFieldsFilled){
                alertDialog(binding.root.context,
                    "Publicación","Todos los campos llenados",
                    "Ok",
                    onPositiveButtonClick = {
                        requireActivity().supportFragmentManager.popBackStack()
                    }
                    )
                message("Todos los campos llenados")
                publishInfo(list = variable)


            }else{
                message(getString(R.string.llena_todos_los_campos))

            }
        }

    }

    private fun publishInfo(list: List<String>){

    }

    private fun setupSpinners(){
        SpinnerUtils.setupSpinner(
            binding.root.context,
            binding.mySpinner,
            R.array.law_categories
        ){ selectedOption ->
            if (!selectedOption.contains("Selecciona")){
                categorySelectedOption = selectedOption
            }
        }

        SpinnerUtils.setupSpinner(
            binding.root.context,
            binding.spinnerRequirements1,
            R.array.requerimientos_cliente
        ){ selectedOption ->
            if (!selectedOption.contains("Selecciona")){
                requirements1SelectedOption = selectedOption
            }
        }
        SpinnerUtils.setupSpinner(
            binding.root.context,
            binding.spinnerRequirements2,
            R.array.requerimientos_cliente
        ){ selectedOption ->
            if (!selectedOption.contains("Selecciona")){
                requirements2SelectedOption = selectedOption
            }
        }
        SpinnerUtils.setupSpinner(
            binding.root.context,
            binding.spinnerTag1,
            R.array.tag_categories
        ){ selectedOption ->
            if (!selectedOption.contains("Selecciona")){
                tag1SelectedOption = selectedOption
            }
        }
        SpinnerUtils.setupSpinner(
            binding.root.context,
            binding.spinnerTag2,
            R.array.tag_categories
        ){ selectedOption ->
            if (!selectedOption.contains("Selecciona")){
                tag2lectedOption = selectedOption
            }
        }
        SpinnerUtils.setupSpinner(
            binding.root.context,
            binding.spinnerTag3,
            R.array.tag_categories
        ){ selectedOption ->
            if (!selectedOption.contains("Selecciona")){
                tag3SelectedOption = selectedOption
            }
        }

    }

}