package mx.com.yourlawyer.yourlawyer.controller

import com.google.firebase.firestore.FirebaseFirestore

class FirebaseManager(private val db: FirebaseFirestore) {

    // Método para obtener un documento
    fun getDocument(
        path: String,
        onSuccess: (Map<String, Any>?) -> Unit,
        onFailure: (Exception) -> Unit
    ) {
        db.document(path).get()
            .addOnSuccessListener { document ->
                if (document.exists()) {
                    onSuccess(document.data)
                } else {
                    onSuccess(null) // Documento no existe
                }
            }
            .addOnFailureListener { e ->
                onFailure(e)
            }
    }

    // Método para establecer (crear o reemplazar) un documento
    fun setDocument(
        path: String,
        data: HashMap<String, String?>,
        onSuccess: () -> Unit,
        onFailure: (Exception) -> Unit
    ) {
        db.document(path).set(data)
            .addOnSuccessListener {
                onSuccess()
            }
            .addOnFailureListener { e ->
                onFailure(e)
            }
    }

    // Método para actualizar un documento existente
    fun updateDocument(
        path: String,
        data: Map<String, Any>,
        onSuccess: () -> Unit,
        onFailure: (Exception) -> Unit
    ) {
        db.document(path).update(data)
            .addOnSuccessListener {
                onSuccess()
            }
            .addOnFailureListener { e ->
                onFailure(e)
            }
    }

    // Método para verificar si un documento existe
    fun documentExists(
        path: String,
        onResult: (Boolean) -> Unit,
        onFailure: (Exception) -> Unit
    ) {
        db.document(path).get()
            .addOnSuccessListener { document ->
                onResult(document.exists())
            }
            .addOnFailureListener { e ->
                onFailure(e)
            }
    }
}