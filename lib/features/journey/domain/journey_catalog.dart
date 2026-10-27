import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'journey_models.dart';

class JourneyCatalog {
  JourneyCatalog(this.zones);

  final List<JourneyZone> zones;

  static JourneyCatalog? _cached;
  static const assetPath = 'assets/data/journey.json';

  JourneyZone? zoneById(String id) {
    for (final z in zones) {
      if (z.id == id) return z;
    }
    return null;
  }

  JourneyNode? nodeById(String id) {
    for (final z in zones) {
      for (final n in z.nodes) {
        if (n.id == id) return n;
      }
    }
    return null;
  }

  String? get firstZoneId => zones.isEmpty ? null : zones.first.id;

  static Future<JourneyCatalog> load({AssetBundle? bundle}) async {
    if (_cached != null) return _cached!;
    final raw = await (bundle ?? rootBundle).loadString(assetPath);
    _cached = parse(raw);
    return _cached!;
  }

  @visibleForTesting
  static JourneyCatalog parse(String raw, {bool enforceGateNonAd = true}) {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final list = (map['zones'] as List<dynamic>? ?? const [])
        .map((e) => JourneyZone.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    if (enforceGateNonAd) {
      for (final z in list) {
        for (final n in z.nodes) {
          if (!n.hasNonAdGate) {
            throw FormatException('Gate ${n.id} missing non-ad path');
          }
        }
      }
    }
    return JourneyCatalog(list);
  }

  @visibleForTesting
  static void debugReset() {
    _cached = null;
  }
}
