package mx.com.yourlawyer.yourlawyer.view
import CasesFragment
import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Spinner
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import loadImage
import message
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.databinding.FragmentProfileBinding
import mx.com.yourlawyer.yourlawyer.model.Profile
import mx.com.yourlawyer.yourlawyer.model.ProfileManager


class ProfileFragment : Fragment() {
    private var _binding: FragmentProfileBinding? = null
    private val binding get() = _binding!!
    private val PICK_IMAGE_REQUEST = 1
    private var selectedImageUri: Uri = Uri.EMPTY

    private val db = FirebaseFirestore.getInstance()
    private val auth = FirebaseAuth.getInstance()
    private lateinit var profileObj: Profile

    private val skills = arrayOf(
        "Selecciona tus habilidades",
        "Derecho Penal", "Derecho Administrativo", "Derecho Civil",
        "Derecho Comercial", "Derecho Laboral", "Derecho Constitucional",
        "Derecho de la Familia", "Derecho de la Justicia", "Derecho de la Constitución"
    ).distinct()

    private val languages = arrayOf(
        "Selecciona tu idioma",
        "Español", "Inglés", "Francés", "Portugués", "Alemán",
        "Italiano", "Japonés", "China","Coreano", "Indonesia", "Filipino", "Arabés",
        "Ruso", "Turco", "Polaco"
    ).distinct()
    private var selectedSkills: List<String> = emptyList()
    private var selectedLanguages: List<String> = emptyList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
       _binding = FragmentProfileBinding.inflate(inflater, container, false)
        val imageUriString = arguments?.getString("imageUri")
        imageUriString?.let { uriString ->
            val imageUri = Uri.parse(uriString)

            loadImage(imageUri, binding.profileImageView, binding.root.context, R.drawable.person_resource)
        }
        checkUserInfo()
        actions()
        return binding.root
    }

    override fun onDestroy() {
        super.onDestroy()
        _binding = null
    }

    private fun actions(){
        binding.closeImageView.setOnClickListener(){
            requireActivity().supportFragmentManager.popBackStack()
        }

        binding.addImageButton.setOnClickListener(){
            val intent = Intent(Intent.ACTION_PICK)
            intent.type = "image/*"
            startActivityForResult(intent, PICK_IMAGE_REQUEST)
        }

        setupSpinners()

        binding.saveBtn.setOnClickListener() {
            if (binding.nameEditText.text.toString()
                    .isEmpty() || binding.lastNameEditText.text.toString().isEmpty() ||
                binding.descriptionEditText.text.toString()
                    .isEmpty() || selectedSkills.isEmpty() || selectedLanguages.isEmpty() || selectedImageUri == Uri.EMPTY
            ) {
                message("Por favor, llena todos los campos y selecciona una imagen de perfil.")
                return@setOnClickListener
            } else {
                saveProfileToFirebase()
                val nextFragment = CasesFragment()
                val bundle = Bundle()
                bundle.putString("imageUri", selectedImageUri.toString())
                nextFragment.arguments = bundle
                requireActivity().supportFragmentManager.beginTransaction()
                    .replace(R.id.fragment_container, nextFragment)
                    .addToBackStack(null)
                    .commit()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == PICK_IMAGE_REQUEST && resultCode == Activity.RESULT_OK) {
            data?.data?.let { imageUri ->
                // Load the image using Glide
                loadImage(imageUri, binding.profileImageView, binding.root.context, R.drawable.person_resource)
                selectedImageUri = imageUri

            }
        }
    }

    private fun setupSpinners() {
        setupSpinner(binding.skillsSpinner, skills) { selectedUserSkill ->
            selectedSkills = listOf(selectedUserSkill)
        }

        setupSpinner(binding.languageSpinner, languages) { selectedUserLanguage ->
            selectedLanguages = listOf(selectedUserLanguage)
        }
    }

    private fun setupSpinner(spinner: Spinner, items: List<String>, onItemSelected: (String) -> Unit)  {
        val adapter = ArrayAdapter(binding.root.context, android.R.layout.simple_spinner_dropdown_item, items)
        spinner.adapter = adapter

        spinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                val selectedItem = parent?.getItemAtPosition(position) as String
                onItemSelected(selectedItem)
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {
                message("Ningún elemento seleccionado")
            }
        }
    }

    private fun saveProfileToFirebase() {
        val userEmail = auth.currentUser?.email
        if (userEmail.isNullOrEmpty()) {
            message("No se encontró el usuario autenticado")
            return
        }

        // Datos a actualizar
        val updatedData = hashMapOf<String, Any?>(
            "name" to binding.nameEditText.text.toString(),
            "lastName" to binding.lastNameEditText.text.toString(),
            "userDescription" to binding.descriptionEditText.text.toString(),
            "skill" to selectedSkills,
            "language" to selectedLanguages
        ).filterValues { it != null } // Eliminar valores nulos

        // Referencia al documento del perfil
        val profileDocRef = db.collection("users")
            .document(userEmail)
            .collection("profile")
            .document("userInformation")

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

    private fun checkUserInfo(){
        val userEmail = auth.currentUser?.email
        if (userEmail.isNullOrEmpty()) {
            message("No se encontró el usuario autenticado")
            return
        }

        val imageUriString = arguments?.getString("imageUri")
        imageUriString?.let { uriString ->
            val imageUri = Uri.parse(uriString)
            selectedImageUri = imageUri
            loadImage(imageUri, binding.profileImageView, binding.root.context, R.drawable.person_resource)
        }

        db.collection("users")
            .document(userEmail)
            .collection("profile")
            .document("userInformation")
            .get()
            .addOnSuccessListener { document ->
                if(document.exists()) {


                    profileObj = Profile(
                        name = document.getString("name") ?: "",
                        lastName = document.getString("lastName") ?: "",
                        email = userEmail,
                        hourlyRate = null,
                        language = document.get("language") as? List<String> ?: emptyList(),
                        skills = document.get("skill") as? List<String> ?: emptyList(),
                        userRole = document.getString("userRole") ?: "",
                        userDescription = document.getString("userDescription")
                    )
                    ProfileManager.setProfile(profileObj)

                    binding.roleTv.setText(profileObj.userRole)
                    binding.nameEditText.setText(profileObj.name)
                    binding.lastNameEditText.setText(profileObj.lastName)
                    binding.descriptionEditText.setText(profileObj.userDescription)

                    profileObj.skills?.firstOrNull()?.let { skill ->
                        val skillIndex = skills.indexOf(skill)
                        if (skillIndex != -1) {
                            binding.skillsSpinner.setSelection(skillIndex)
                        }
                    }
                    profileObj.language?.firstOrNull()?.let { language ->
                        val languageIndex = languages.indexOf(language)
                        if (languageIndex != -1) {
                            binding.languageSpinner.setSelection(languageIndex)
                        }
                    }
                }else{
                    message("No se encontró el perfil")
                }
            }
            .addOnFailureListener { e ->
                message("Error al guardar el perfil: ${e.message}")
            }
    }


}