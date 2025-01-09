package mx.com.yourlawyer.yourlawyer.view.adapters
//
//package com.yourlawyer

import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.fragment.app.Fragment
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import message
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.controller.FirebaseManager
import mx.com.yourlawyer.yourlawyer.databinding.FragmentSignUpBinding

class SignUpFragment : Fragment() {
    private var _binding: FragmentSignUpBinding? = null
    private val binding get() = _binding!!

    private val db = FirebaseFirestore.getInstance()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        // Inflate the layout for this fragment
        _binding = FragmentSignUpBinding.inflate(inflater, container, false)

        binding.joinButton.setOnClickListener { signUpAction() }

        return binding.root
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        view.setBackgroundColor(Color.WHITE)
    }

    override fun onDestroy() {
        super.onDestroy()
        _binding = null
    }

    private fun signUpAction() {
        binding.activityIndicator.visibility = View.VISIBLE

        if (!binding.termsCheckbox.isChecked) {
            binding.activityIndicator.visibility = View.GONE
            message("Selecciona los términos y condiciones.")
            return
        }

        val email = binding.emailEditText.text.toString().trim()
        val password = binding.passwordEditText.text.toString().trim()
        val firstName = binding.nameEditText.text.toString().trim()
        val lastName = binding.lastNameEditText.text.toString().trim()

        if (email.isEmpty() || password.isEmpty() || firstName.isEmpty() || lastName.isEmpty()) {
            binding.activityIndicator.visibility = View.GONE
            message("Por favor, completa todos los campos.")
            return
        }

        FirebaseAuth.getInstance().createUserWithEmailAndPassword(email, password)
            .addOnCompleteListener { task ->
                binding.activityIndicator.visibility = View.GONE
                if (task.isSuccessful) {
                    val selectedRole = when (binding.typeSegmentedControl.checkedRadioButtonId) {
                        R.id.clientOption -> "Cliente"
                        R.id.lawyerOption -> "Abogado"
                        else -> ""
                    }
                    if (selectedRole.isEmpty()) {
                        message("Selecciona un rol.")
                        return@addOnCompleteListener
                    }

                    message("Usuario registrado exitosamente. Por favor, inicia sesión.")

                    db.collection("users").document(email).collection("profile")
                        .document("userInformation").set(hashMapOf(
                        "name" to firstName,
                        "lastName" to lastName,
                        "email" to email,
                        "hourlyRate" to null,
                        "language" to listOf<String>(),
                        "skills" to listOf<String>(),
                        "userRole" to selectedRole,
                        "userDescription" to null,
                    ))
                    requireActivity().supportFragmentManager.popBackStack()

                } else {
                    message("Error al registrar: ${task.exception?.message}")
                }
            }
    }

}