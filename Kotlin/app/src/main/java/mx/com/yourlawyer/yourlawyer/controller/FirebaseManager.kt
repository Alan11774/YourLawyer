package mx.com.yourlawyer.yourlawyer.controller

import com.google.firebase.firestore.FirebaseFirestore

object FirebaseManager {

    fun userProfileOperation(
        db: FirebaseFirestore,
        userEmail: String,
        data: Map<String, Any>,
        operation: String = "set",
        onSuccess: () -> Unit,
        onFailure: (Exception) -> Unit
    ) {
        val profileDocRef = db.collection("users")
            .document(userEmail)
            .collection("profile")
            .document("userInformation")

        when (operation) {
            "set" -> {
                profileDocRef.set(data)
                    .addOnSuccessListener { onSuccess() }
                    .addOnFailureListener { onFailure(it) }
            }
            "update" -> {
                profileDocRef.update(data)
                    .addOnSuccessListener { onSuccess() }
                    .addOnFailureListener { onFailure(it) }
            }
            "get" -> {
                profileDocRef.get()
                    .addOnSuccessListener { document ->
                        if (document.exists()) {
                            onSuccess() // You can pass the data here if needed: onSuccess(document.data)
                        } else {
                            onFailure(Exception("Document does not exist"))
                        }
                    }
                    .addOnFailureListener { onFailure(it) }
            }
            else -> {
                onFailure(Exception("Invalid operation: $operation"))
            }
        }
    }
}