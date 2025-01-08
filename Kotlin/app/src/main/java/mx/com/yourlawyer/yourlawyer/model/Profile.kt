package mx.com.yourlawyer.yourlawyer.model

data class Profile(
    val name: String,
    val lastName: String?,
    val email: String,
    val hourlyRate: Double?,
    val language: List<String?>?,
    val skills: List<String?>?,
    val userRole: String,
    val userDescription: String?,
)

object ProfileManager {

    private var profile: Profile? = null

    fun setProfile(setProfile: Profile) {
        profile = setProfile
    }

    fun getProfile(): Profile? {
        return profile
    }
}