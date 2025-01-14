import android.widget.Toast
import android.app.Activity
import android.content.Context
import android.net.Uri
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.EditText
import android.widget.ImageView
import android.widget.Spinner
import androidx.appcompat.app.AlertDialog
import androidx.core.content.ContextCompat.getSystemService
import androidx.fragment.app.Fragment
import com.bumptech.glide.Glide
import mx.com.yourlawyer.yourlawyer.R


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
//************************************************************************
// General popup messages
//************************************************************************
fun alertDialog(context: Context, title: String, message: String,
                positiveButton: String = "Ok",
                negativeButton: String? = null,
                onPositiveButtonClick: (() -> Unit)? = null,
                onNegativeButtonClick: (() -> Unit)? = null
) {
    val builder = AlertDialog.Builder(context,R.style.CustomAlertDialogTheme)
    builder.setTitle(title)
    builder.setMessage(message)

    builder.setPositiveButton(positiveButton) { _, _ ->
        onPositiveButtonClick?.invoke()

    }
if (negativeButton != null){
    builder.setNegativeButton("No") { dialog, _ ->
        onPositiveButtonClick?.invoke()
        dialog.dismiss()
    }
}

    val dialog = builder.create()
    dialog.show()
}

object SpinnerUtils {

    fun setupSpinner(
        context: Context,
        spinner: Spinner,
        arrayResourceId: Int,
        itemLayoutResourceId: Int =  R.layout.spinner_item,
        dropdownLayoutResourceId: Int = R.layout.custom_spinner_dropdown,
        onItemSelected: (String) -> Unit
    ) {
        val adapter = ArrayAdapter.createFromResource(
            context,
            arrayResourceId,
            itemLayoutResourceId
        )
        adapter.setDropDownViewResource(dropdownLayoutResourceId)
        spinner.adapter = adapter

        spinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View?,
                position: Int,
                id: Long
            ) {
                val selectedOption = parent?.getItemAtPosition(position).toString()
                onItemSelected(selectedOption)
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {
                onItemSelected("")
            }
        }
    }
}