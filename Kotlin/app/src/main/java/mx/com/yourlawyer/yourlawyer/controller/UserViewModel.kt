package mx.com.yourlawyer.yourlawyer.controller

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch
import mx.com.yourlawyer.yourlawyer.model.Case
import mx.com.yourlawyer.yourlawyer.model.Lawyer
import mx.com.yourlawyer.yourlawyer.model.Profile

class UserViewModel : ViewModel() {
    val userProfile = MutableLiveData<Profile>()
    val lawyerProfile = MutableLiveData<Lawyer>()
    val caseProfile = MutableLiveData<Case>()

    fun setUserProfile(userProfile: Profile) {
        this.userProfile.value = userProfile
    }

    fun setLawyerProfile(lawyerProfile: Lawyer) {
        this.lawyerProfile.value = lawyerProfile
    }

    fun setCaseProfile(caseProfile: Case) {
        this.caseProfile.value = caseProfile
    }
}

//*************************************************************
// MainViewModel Example
//*************************************************************
//class MainViewModel: ViewModel() {
//
//    private val _anime = MutableLiveData<AnimeDto>() // This is the Mutable versiomn
//
//    val anime: LiveData<AnimeDto> = _anime // This is the immutable version
//
//
//    fun updateAnime(){
//        viewModelScope.launch{
//            _anime.postValue(AnimeProvider.getAnime())
//        }
//    }
//}