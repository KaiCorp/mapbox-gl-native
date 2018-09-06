package com.mapbox.mapboxsdk.annotations.symbol;

import android.support.v4.util.LongSparseArray;
import com.mapbox.geojson.Point;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.maps.MapboxMap;
import com.mapbox.mapboxsdk.style.layers.SymbolLayer;
import com.mapbox.mapboxsdk.style.sources.GeoJsonSource;
import org.junit.Before;
import org.junit.Test;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertTrue;
import static org.mockito.Mockito.mock;

public class SymbolManagerTest {

  private MapboxMap mapboxMap = mock(MapboxMap.class);
  private GeoJsonSource geoJsonSource = mock(GeoJsonSource.class);
  private SymbolLayer symbolLayer = mock(SymbolLayer.class);
  private SymbolManager symbolManager;

  @Before
  public void beforeTest() {
    symbolManager = new SymbolManager(mapboxMap, geoJsonSource, symbolLayer);
  }

  @Test
  public void testAddSymbol() {
    final Symbol symbol = symbolManager.createSymbol(new LatLng(12, 34));
    assertEquals(symbolManager.getSymbols().get(0), symbol);
  }

  @Test
  public void testDeleteSymbol() {
    Symbol symbol = symbolManager.createSymbol(new LatLng(12, 34));
    symbolManager.deleteSymbol(symbol);
    assertTrue(symbolManager.getSymbols().size() == 0);
  }

  @Test
  public void testGeometrySymbol() {
    Symbol symbol = symbolManager.createSymbol(new LatLng(12, 34));
    assertEquals(symbol.getGeometry(), Point.fromLngLat(34, 12));
  }

  @Test
  public void testFeatureIdSymbol() {
    Symbol symbolZero = symbolManager.createSymbol(new LatLng());
    Symbol symbolOne = symbolManager.createSymbol(new LatLng());
    assertEquals(symbolZero.getFeature().get(Symbol.ID_KEY).getAsLong(), 0);
    assertEquals(symbolOne.getFeature().get(Symbol.ID_KEY).getAsLong(), 1);
  }
}