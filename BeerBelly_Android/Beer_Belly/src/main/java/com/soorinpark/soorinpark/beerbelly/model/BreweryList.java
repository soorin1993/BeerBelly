package com.soorinpark.soorinpark.beerbelly.model;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by soorinpark on 11/8/16.
 */

public class BreweryList {

    @SerializedName("totalResults")
    private int totalResults;
    @SerializedName("data")
    private List<Brewery> brewData;

    public int getTotalResults() { return totalResults; }
    public List<Brewery> getDataList() {
        return brewData;
    }

}
