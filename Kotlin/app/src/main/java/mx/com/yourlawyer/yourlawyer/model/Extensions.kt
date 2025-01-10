import android.widget.Toast
import android.app.Activity
import android.content.Context
import android.net.Uri
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import android.widget.ImageView
import androidx.core.content.ContextCompat.getSystemService
import androidx.fragment.app.Fragment
import com.bumptech.glide.Glide


fun Activity.message(message: String, duration: Int = Toast.LENGTH_SHORT){
    Toast.makeText(
          this,
        message,
        duration
    ).show()
}

fun Fragment.message(message: String, duration: Int = Toast.LENGTH_SHORT) {
    Toast.makeText(requireContext(), message, duration).show()
}

fun loadImage(uri: Any, imageView: ImageView, context: Context, placeholderResId: Int? = null, scaleType: String = "circleCrop") {
    val requestBuilder = Glide.with(context).load(uri)
    placeholderResId?.let {
        requestBuilder.placeholder(it)
    }
    when (scaleType) {
        "circleCrop" -> requestBuilder.circleCrop()
        "centerCrop" -> requestBuilder.centerCrop()
        else -> {
            throw IllegalArgumentException("Invalid scale type: $scaleType")
        }
    }
    requestBuilder.into(imageView)
}


//************************************************************************
// Guardar Uri en shared preferences (Sera usado para obtener siempre la
// imagen de perfil incluso despues de cerrar la app.
//************************************************************************
fun saveUri(context:Context ,uri: Uri){
    val sharedPreferences = context.getSharedPreferences("MyPreferences", Context.MODE_PRIVATE)
    val editor = sharedPreferences.edit()
    editor.putString("imageUri", uri.toString())
    editor.apply()
}

fun getUri(context: Context): Uri? {
    val sharedPreferences = context.getSharedPreferences("MyPreferences", Context.MODE_PRIVATE)
    val uriString = sharedPreferences.getString("imageUri", null)
    return uriString?.let { Uri.parse(it) }
}