import { ConfigService } from '@nestjs/config';
import { IsochroneService } from '../adapters.module';

export class OsrmIsochroneAdapter implements IsochroneService {
  private readonly osrmUrl: string;

  constructor(private readonly config: ConfigService) {
    this.osrmUrl = config.get<string>('OSRM_URL') ?? 'http://osrm:5000';
  }

  async getIsochrone(
    lat: number,
    lng: number,
    minutes: number,
    mode: 'walk' | 'bike' | 'car',
  ): Promise<object> {
    void mode;
    const radiusMeters = minutes * 80;
    return {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [lng, lat],
      },
      properties: {
        contours: [{ time: minutes, distance: radiusMeters }],
        source: 'osrm-approximation',
        osrmUrl: this.osrmUrl,
      },
    };
  }
}
