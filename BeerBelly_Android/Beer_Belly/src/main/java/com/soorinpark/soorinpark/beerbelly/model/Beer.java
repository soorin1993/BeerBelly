package com.soorinpark.soorinpark.beerbelly.model;

import com.google.gson.annotations.SerializedName;

/**
 * Created by soorinpark on 11/11/16.
 */

public class Beer {
    @SerializedName("id")
    private String beerId;

    @SerializedName("name")
    private String beerName;

    @SerializedName("styleId")
    private String beerStyleId;

    @SerializedName("description")
    private String beerDescription;

    public Beer(String beerId, String beerName, String beerStyleId, String beerDescription) {
        this.beerId = beerId;
        this.beerName = beerName;
        this.beerStyleId = beerStyleId;
        this.beerDescription = beerDescription;
    }

    public String getBeerId() { return beerId; }
    public String getBeerName() { return beerName; }
    public String getBeerStyleId() { return beerStyleId; }
    public String getBeerDescription() { return beerDescription; }

}
