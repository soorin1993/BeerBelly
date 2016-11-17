package com.soorinpark.soorinpark.beerbelly.activity;

import android.Manifest;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import com.soorinpark.soorinpark.beerbelly.R;


/**
 * Created by soorinpark on 11/8/16.
 */
/* you can get brewery data from the beer list. use the brewery id obtained from the beer list to
also match for a brewery in the local brewery list and if they overlap, return the
overlapping brewery as well as the beer type.
 */

public class MainActivity extends AppCompatActivity {

    private Boolean currentLocation = false;

    private EditText city;
    private EditText zipcode;
    private Spinner stateSpinner;
    private Spinner styleSpinner;

    private String cityText;
    private String zipcodeText;
    private String stateText;
    private String beerStyle;
    private Handler handler;

    private Context context;

    private static final int REQUEST_CODE_LOCATION = 2;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, REQUEST_CODE_LOCATION);

        }
        styleSpinner = (Spinner) findViewById(R.id.beerCategory);
        ArrayAdapter styleAdapter = ArrayAdapter.createFromResource(this, R.array.styles, R.layout.spinner_item);
        styleAdapter.setDropDownViewResource(R.layout.spinner_dropdown_item);
        styleSpinner.isEnabled();
        styleSpinner.setAdapter(styleAdapter);

        stateSpinner = (Spinner) findViewById(R.id.stateSpinner);
        ArrayAdapter stateAdapter = ArrayAdapter.createFromResource(this, R.array.states, R.layout.spinner_item);
        stateAdapter.setDropDownViewResource(R.layout.spinner_dropdown_item);
        stateSpinner.setAdapter(stateAdapter);


        Typeface headFont = Typeface.createFromAsset(getAssets(), "fonts/Bungee-Regular.ttf");
        Typeface bodyFont = Typeface.createFromAsset(getAssets(), "fonts/OpenSans-Regular.ttf");

        //BEER BELLY Title
        TextView titleTextView = (TextView) findViewById(R.id.textView);
        titleTextView.setTypeface(headFont);

        TextView likeTextView = (TextView) findViewById(R.id.textView2);
        likeTextView.setTypeface(headFont);

        TextView liveTextView = (TextView) findViewById(R.id.liveTextView);
        liveTextView.setTypeface(headFont);

        city = (EditText) findViewById(R.id.cityEditText);
        city.setTypeface(bodyFont);

        zipcode = (EditText) findViewById(R.id.zipEditText);
        zipcode.setTypeface(bodyFont);

        Button drinkButton = (Button) findViewById(R.id.drinkButton);
        drinkButton.setTypeface(bodyFont);
        drinkButton.setOnClickListener(drinkHandler);
    }

    View.OnClickListener drinkHandler = new View.OnClickListener() {
        public void onClick(View v) {

            cityText = city.getText().toString();
            zipcodeText = zipcode.getText().toString();
            if (stateSpinner.getSelectedItemPosition() == 0) {
                stateText = "";
            } else {
                stateText = stateSpinner.getSelectedItem().toString();
            }

            if (styleSpinner.getSelectedItemPosition() == 0) {
                beerStyle = "";
            } else {
                beerStyle = String.valueOf(styleSpinner.getSelectedItemPosition());
            }

            if (cityText.matches("") ^ stateText.matches("")) {
                //Be sure to pass your Activity class, not the Thread
                AlertDialog alertDialog = new AlertDialog.Builder(MainActivity.this).create();
                alertDialog.setTitle("Error");
                alertDialog.setCancelable(false);
                alertDialog.setMessage("Please enter in both city and state parameters");
                alertDialog.setButton(AlertDialog.BUTTON_POSITIVE, "OK",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                            }
                        });
                alertDialog.show();

            }
            else {
                changeView();
            }
        }
    };

    public void changeView() {
        if (cityText.matches("") && stateText.matches("") && zipcodeText.matches("")) {
            currentLocation = true;
        } else {
            currentLocation = false;
        }
//        Log.d("vals1", zipcodeText + "-" + cityText + "-" + stateText + "-" + currentLocation);

        Intent intent = new Intent(MainActivity.this, BrewActivity.class);
        intent.putExtra("zipcode", zipcodeText);
        intent.putExtra("city", cityText);
        intent.putExtra("state", stateText);
        intent.putExtra("current", currentLocation);
        intent.putExtra("beerStyle", beerStyle);
        startActivity(intent);
    }
}
