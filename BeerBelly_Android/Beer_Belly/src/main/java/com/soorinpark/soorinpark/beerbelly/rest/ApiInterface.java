package com.soorinpark.soorinpark.beerbelly.rest;

import com.soorinpark.soorinpark.beerbelly.model.BeerList;
import com.soorinpark.soorinpark.beerbelly.model.BreweryList;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Path;
import retrofit2.http.Query;

/**
 * Created by soorinpark on 11/8/16.
 http://api.brewerydb.com/v2/locations?key=546e79849610632a56e3ea49a776f1ba&postalCode=80302 // zipcode
 http://api.brewerydb.com/v2/brewery/vxzuxc/beers?key=546e79849610632a56e3ea49a776f1ba // beer list of a brewery
 */


public interface ApiInterface {

    @GET("locations")
    Call<BreweryList> getBrewZip(@Query("key") String apiKey, @Query("postalCode") String zipCode);

    @GET("locations")
    Call<BreweryList> getBrewLongLat(@Query("key") String apiKey, @Query("latitude") String latitude, @Query("longitude") String longitude);

    @GET("locations")
    Call<BreweryList> getBrewCityState(@Query("key") String apiKey, @Query("locality") String city, @Query("region") String state);

    @GET("brewery/{breweryId}/beers")
    Call<BeerList> getBeerFromBrew(@Path("breweryId") String breweryId, @Query("key") String apiKey);

//    @GET("movie/{id}")
//    Call<BreweryList> getMovieDetails(@Path("id") int id, @Query("api_key") String apiKey);
}
