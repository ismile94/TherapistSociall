// Mapbox Geocoding service for getting coordinates from city names
import { config } from '../../../config/env.config';

export interface GeocodeResult {
  latitude: number;
  longitude: number;
  placeName: string;
}

export class MapboxGeocodingService {
  private static readonly baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';

  /**
   * Geocode a city name to get coordinates
   * Returns the first result's coordinates
   */
  static async geocodeCity(cityName: string): Promise<GeocodeResult | null> {
    if (!cityName || cityName.trim().length === 0) {
      return null;
    }

    try {
      const encodedCity = encodeURIComponent(cityName);
      const params = new URLSearchParams({
        access_token: config.mapbox.accessToken,
        types: 'place',
        limit: '1',
      });
      
      const url = `${this.baseUrl}/${encodedCity}.json?${params.toString()}`;
      const response = await fetch(url);

      if (!response.ok) {
        throw new Error(`Mapbox API error: ${response.status}`);
      }

      const data = await response.json();

      if (data && data.features && data.features.length > 0) {
        const feature = data.features[0];
        const [longitude, latitude] = feature.geometry.coordinates;
        const placeName = feature.place_name || feature.text;

        return {
          latitude,
          longitude,
          placeName,
        };
      }
    } catch (error) {
      console.error('Mapbox Geocoding error:', error);
    }

    return null;
  }
}

