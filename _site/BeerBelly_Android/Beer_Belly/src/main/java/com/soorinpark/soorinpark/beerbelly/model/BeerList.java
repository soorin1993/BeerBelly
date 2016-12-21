package com.soorinpark.soorinpark.beerbelly.model;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by soorinpark on 11/11/16.
 */

public class BeerList {

    @SerializedName("data")
    private List<Beer> beerData;

    public List<Beer> getBeerList() { return beerData; }

}
