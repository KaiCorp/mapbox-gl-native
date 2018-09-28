package com.mapbox.mapboxsdk.style.types;

import android.support.annotation.Keep;
import android.support.annotation.Nullable;

import java.util.Arrays;

/**
 * A component of the {@link Formatted}.
 */
@Keep
public class FormattedSection {
  private String text;
  private double fontScale;
  private String[] fontStack;

  /**
   * Creates a formatted section.
   *
   * @param text      displayed string
   * @param fontScale scale of the font, 1.0 is default
   * @param fontStack main and fallback fonts that are a part of the style
   */
  public FormattedSection(String text, double fontScale, String[] fontStack) {
    this.text = text;
    this.fontScale = fontScale;
    this.fontStack = fontStack;
  }

  /**
   * Returns the displayed text.
   *
   * @return text
   */
  public String getText() {
    return text;
  }

  /**
   * Returns displayed text's font scale.
   *
   * @return font scale, defaults to 1.0
   */
  public double getFontScale() {
    return fontScale;
  }

  /**
   * Returns the font stack with main and fallback fonts.
   *
   * @return font stack
   */
  @Nullable
  public String[] getFontStack() {
    return fontStack;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }

    FormattedSection section = (FormattedSection) o;

    return Double.compare(section.fontScale, fontScale) == 0
      && (text != null ? text.equals(section.text) : section.text == null)
      && Arrays.equals(fontStack, section.fontStack);
  }

  @Override
  public int hashCode() {
    int result;
    long temp;
    result = text != null ? text.hashCode() : 0;
    temp = Double.doubleToLongBits(fontScale);
    result = 31 * result + (int) (temp ^ (temp >>> 32));
    result = 31 * result + Arrays.hashCode(fontStack);
    return result;
  }
}
