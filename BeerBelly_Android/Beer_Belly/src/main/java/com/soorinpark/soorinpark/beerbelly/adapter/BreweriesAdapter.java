package com.soorinpark.soorinpark.beerbelly.adapter;

/**
 * Created by soorinpark on 11/10/16.
 */

import android.content.Context;
import android.graphics.Typeface;
import android.os.StrictMode;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.soorinpark.soorinpark.beerbelly.R;
import com.soorinpark.soorinpark.beerbelly.model.Beer;
import com.soorinpark.soorinpark.beerbelly.model.BeerList;
import com.soorinpark.soorinpark.beerbelly.model.Brewery;
import com.soorinpark.soorinpark.beerbelly.rest.ApiInterface;

import java.io.IOException;
import java.util.List;

import retrofit2.Call;
import retrofit2.Response;

import static com.soorinpark.soorinpark.beerbelly.activity.BrewActivity.API_KEY;

public class BreweriesAdapter extends RecyclerView.Adapter<BreweriesAdapter.BreweryViewHolder> {

    private String beerStyleId;
    private ApiInterface apiService;
    private int rowLayout;
    private Context context;

    private List<Brewery> brews;



    public static class BreweryViewHolder extends RecyclerView.ViewHolder {

        LinearLayout brewLayout;
        TextView brewName;
        TextView brewStreet;
        TextView brewCityStateZip;
        TextView brewPhone;
        TextView brewWeb;
        ImageView beerIcon;


        public BreweryViewHolder(View v) {
            super(v);
            brewLayout = (LinearLayout) v.findViewById(R.id.brewery_layout);
            brewName = (TextView) v.findViewById(R.id.brewery_name);
            brewStreet = (TextView) v.findViewById(R.id.brewery_street);
            brewCityStateZip = (TextView) v.findViewById(R.id.brewery_city_state_zipcode);
            brewPhone = (TextView) v.findViewById(R.id.brewery_phone);
            brewWeb = (TextView) v.findViewById(R.id.brewery_web);
            beerIcon = (ImageView) v.findViewById(R.id.beercanIcon);

            Typeface headFont = Typeface.createFromAsset(v.getContext().getAssets(), "fonts/Bungee-Regular.ttf");
            Typeface bodyFont = Typeface.createFromAsset(v.getContext().getAssets(), "fonts/OpenSans-Regular.ttf");
            this.brewName.setTypeface(headFont);
            this.brewStreet.setTypeface(bodyFont);
            this.brewCityStateZip.setTypeface(bodyFont);
            this.brewPhone.setTypeface(bodyFont);
            this.brewWeb.setTypeface(bodyFont);
        }
    }

    public BreweriesAdapter(List<Brewery> brews, String beerStyleId, ApiInterface apiService, int rowLayout, Context context) {
        this.brews = brews;
        this.beerStyleId = beerStyleId;
        this.apiService = apiService;
        this.rowLayout = rowLayout;
        this.context = context;
    }

    @Override
    public BreweriesAdapter.BreweryViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(rowLayout, parent, false);
        return new BreweryViewHolder(view);
    }


    @Override
    public void onBindViewHolder(BreweryViewHolder holder, final int position) {


        String breweryId = brews.get(position).getBreweryId();
        Call<BeerList> call = apiService.getBeerFromBrew(breweryId, API_KEY);

        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);

        try {
            Response<BeerList> response = call.execute();
            List<Beer>  beers = response.body().getBeerList();
            if(beers == null) {
                holder.beerIcon.setImageResource(R.drawable.no_beer);
            }
            else {
                //List<Beer> beerList = beers.get(position);
                holder.beerIcon.setImageResource(R.drawable.no_beer);
                for (int i=0; i < beers.size(); i++) {
                    if (beers.get(i) == null || beerStyleId == null || beers.get(i).getBeerStyleId() == null) {
                        holder.beerIcon.setImageResource(R.drawable.no_beer);
                    }
                    else {
                        if (beers.get(i).getBeerStyleId().matches(beerStyleId)) {
                            //TODO
                            // make page changes so it's not loading so many on one page
                            holder.beerIcon.setImageResource(R.drawable.yes_beer);
                        }
                    }

                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }




        Brewery brewObj = brews.get(position).getBrewery();

        holder.brewName.setText(brewObj.getName());

        if (brewObj.getWebsite() == null) {
            holder.brewWeb.setVisibility(View.GONE);
        }
        else {
            holder.brewWeb.setText(brewObj.getWebsite());
        }

        String street = brews.get(position).getStreet();
        String city = brews.get(position).getCity();
        String state = brews.get(position).getState();
        String zip = brews.get(position).getZipcode();
        String csz = city + ", " + state + " " + zip;


        holder.brewStreet.setText(street);
        holder.brewCityStateZip.setText(csz);

        if (brews.get(position).getPhone() == null) {
            holder.brewPhone.setVisibility(View.GONE);
        }
        else {
            holder.brewPhone.setText(brews.get(position).getPhone());
        }

    }

    @Override
    public int getItemCount() {
        return brews.size();
    }

}
