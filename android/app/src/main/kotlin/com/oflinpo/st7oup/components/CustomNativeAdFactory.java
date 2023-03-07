package com.oflinpo.st7oup.components;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.widget.TextView;

import com.oflinpo.st7oup.R;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;

import java.util.Map;

import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;

public class CustomNativeAdFactory implements NativeAdFactory {
    private final LayoutInflater layoutInflater;

    public CustomNativeAdFactory(LayoutInflater layoutInflater) {
        this.layoutInflater = layoutInflater;
    }

    @Override
    public NativeAdView createNativeAd(
            NativeAd nativeAd, Map<String, Object> customOptions) {
        final NativeAdView adView =
                (NativeAdView) layoutInflater.inflate(R.layout.ad_layout, null);
        final TextView headlineView = adView.findViewById(R.id.ad_headline);
        final TextView bodyView = adView.findViewById(R.id.ad_body);

        headlineView.setText(nativeAd.getHeadline());
        bodyView.setText(nativeAd.getBody());

        adView.setBackgroundColor(Color.YELLOW);

        adView.setNativeAd(nativeAd);
        adView.setBodyView(bodyView);
        adView.setHeadlineView(headlineView);
        return adView;
    }
}