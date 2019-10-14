package com.cgsdemoapp;

import android.content.Intent;
import android.os.Bundle;
import android.os.Process;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;

import com.company.product.OverrideUnityActivity;

public class MainUnityActivity extends OverrideUnityActivity {
    // Setup activity layout
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // setContentView(R.layout.MainActivity);
        // addControlsToUnityFrame();
        FrameLayout layout = mUnityPlayer;
        Intent intent = getIntent();
        handleIntent(intent);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        handleIntent(intent);
        setIntent(intent);
    }

    void handleIntent(Intent intent) {
        if(intent == null || intent.getExtras() == null) return;

        if(intent.getExtras().containsKey("doQuit"))
            if(mUnityPlayer != null) {
                finish();
            }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        
        // addControlsToUnityFrame();
    }

    @Override
    protected void onStop() {
        super.onStop();
        // mUnityPlayer.unload();
        // super.onDestroy();
        // finish();
    }
    
    @Override
    protected void showMainActivity(String setToColor) {
        Intent intent = new Intent(this, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT); // | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        intent.putExtra("setColor", setToColor);
        // startActivity(intent);
        finish();
        // mUnityPlayer.unload();

        ///////////////
        //FrameLayout layout = mUnityPlayer;
        // 
    }

    // ss

    @Override public void onUnityPlayerUnloaded() {
        showMainActivity("");
    }

    // public void addControlsToUnityFrame() {
    //     {
    //         Button myButton = new Button(this);
    //         myButton.setText("Show Main");
    //         myButton.setX(10);
    //         myButton.setY(500);

    //         myButton.setOnClickListener(new View.OnClickListener() {
    //             public void onClick(View v) {
    //                showMainActivity("");
    //             }
    //         });
    //         getUnityFrameLayout().addView(myButton, 300, 200);
    //     }

    //     {
    //         Button myButton = new Button(this);
    //         myButton.setText("Send Msg");
    //         myButton.setX(320);
    //         myButton.setY(500);
    //         myButton.setOnClickListener( new View.OnClickListener() {
    //             public void onClick(View v) {
    //                 UnitySendMessage("Cube", "ChangeColor", "yellow");
    //             }
    //         });
    //         getUnityFrameLayout().addView(myButton, 300, 200);
    //     }

    //     {
    //         Button myButton = new Button(this);
    //         myButton.setText("Unload");
    //         myButton.setX(630);
    //         myButton.setY(500);

    //         myButton.setOnClickListener(new View.OnClickListener() {
    //             public void onClick(View v) {
    //                 finish();
    //             }
    //         });
    //         getUnityFrameLayout().addView(myButton, 300, 200);
    //     }
    // }


}
