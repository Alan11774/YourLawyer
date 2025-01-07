package mx.com.yourlawyer.yourlawyer.model

import retrofit2.Call
import retrofit2.http.GET


interface LawyersApi {
    @GET("all/lawyers")
    fun getLawyers(): Call<LawyersResponse>

    @GET("all/cases")
    fun getCases(): Call<CasesResponse>
}