package mx.com.yourlawyer.yourlawyer.view

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.bumptech.glide.Glide
import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.firestore
import loadImage
import message
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.controller.UserViewModel
import mx.com.yourlawyer.yourlawyer.databinding.FragmentDetailCaseBinding
import mx.com.yourlawyer.yourlawyer.databinding.FragmentDetailLawyerBinding
import mx.com.yourlawyer.yourlawyer.databinding.FragmentProfileBinding
import mx.com.yourlawyer.yourlawyer.model.Case

class DetailLawyerFragment : Fragment() {
    private var _binding: FragmentDetailLawyerBinding? = null
    private val binding get() = _binding!!

    private val auth = FirebaseAuth.getInstance()
    private val db = FirebaseFirestore.getInstance()

    private val userViewModel by lazy {
        ViewModelProvider(requireActivity())[UserViewModel::class.java] }


    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentDetailLawyerBinding.inflate(inflater, container, false)
        setupUI()
        //getCaseStatus()
        // Configurar listeners para los botones
        binding.contactButton.setOnClickListener { contactAction() }
        binding.contractButton.setOnClickListener { contractAction() }

        return binding.root
    }

    private fun setupUI() {

        binding.apply {
            userViewModel.lawyerProfile.observe(viewLifecycleOwner){ lawyerProfile ->
                lawyerProfile.imageURL?.let {
                    loadImage(
                        it, binding.lawyerImageView, binding.root.context,
                        R.drawable.legal)
                }
                lawyerName.text = lawyerProfile.name
                ratingLabel.text = "⭐ ${ lawyerProfile.rating}"
                categoryLabel.text = lawyerProfile.description
                descriptionLabel.text = lawyerProfile.userDescription
                lawyerLocationLabel.text = "Ubicación: ${lawyerProfile.location}"
                priceHourLabel.text = "Precio por hora: ${lawyerProfile.hourlyRate.toString()}"
                contractNumberLabel.text = "Numero de contrataciones: ${ lawyerProfile.numberOfHirings.toString() }"
                language.text = "Lenguage: ${lawyerProfile.language}"
                profileViewsLabel.text = "Vistas al perfil: ${ lawyerProfile.profileViews.toString() }"
                projectsWorkedLabel.text = "Numero de casos trabajados: ${lawyerProfile.projectsWorkedOn.toString()}"
                skills1.text = lawyerProfile.skills[0]
                skills2.text = lawyerProfile.skills[1]
            }
        }
    }

    private fun contactAction() {
        requireActivity().supportFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, ChatContactFragment())
            .addToBackStack(null)
            .commit()
    }

    private fun contractAction() {
        requireActivity().supportFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, CheckoutFragment())
            .addToBackStack(null)
            .commit()
    }


    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

}