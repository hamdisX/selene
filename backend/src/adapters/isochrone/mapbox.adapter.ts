import { ConfigService } from '@nestjs/config';
import { IsochroneService } from '../adapters.module';

export class MapboxIsochroneAdapter implements IsochroneService {
  constructor(private readonly config: ConfigService) {}

  async getIsochrone(
    lat: number,
    lng: number,
    minutes: number,
    mode: 'walk' | 'bike' | 'car',
  ): Promise<object> {
    void lat;
    void lng;
    void minutes;
    void mode;
    throw new Error('Mapbox Isochrone adapter — implémenter avec MAPBOX_TOKEN');
  }
}
