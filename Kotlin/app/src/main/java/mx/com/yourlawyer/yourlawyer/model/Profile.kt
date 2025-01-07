package mx.com.yourlawyer.yourlawyer.model

data class Profile(
    val name: String,
    val email: String,
    val hourlyRate: Double,
    val language : List<String>,
    val skills : List<String>,
    val userRole : String,
    val userDescription : String
)
