import android.widget.Toast
import android.app.Activity
import androidx.fragment.app.Fragment


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