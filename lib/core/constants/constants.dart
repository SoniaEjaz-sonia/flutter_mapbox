import 'package:flutter_dotenv/flutter_dotenv.dart';

const String supabaseURL = "https://edzjwvgkcpdowdyksbun.supabase.co";

const String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';

String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
String navType = 'driving';
