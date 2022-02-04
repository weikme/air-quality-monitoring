// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'random_facts_model.g.dart';

@JsonSerializable(
  createToJson: false,
  fieldRename: FieldRename.snake,
)
class RandomFactsModel {
  ///Json fields
  /// "id": "f4ae0ab2-8c91-4bde-be93-05793b149117",
  /// "text": "Eating the heart of a male Partridge was the cure for impotence in ancient Babylon.",
  /// "source": "djtech.net",
  /// "source_url": "http://www.djtech.net/humor/useless_facts.htm",
  /// "language": "en",
  /// "permalink": "https://uselessfacts.jsph.pl/f4ae0ab2-8c91-4bde-be93-05793b149117"

  final String? id;
  final String? text;
  final String? source;
  final String? source_url;
  final String? language;
  final String? permalink;

  RandomFactsModel({
    this.id,
    this.text,
    this.source,
    this.source_url,
    this.language,
    this.permalink,
  });

  factory RandomFactsModel.fromJson(Map<String, dynamic> json) =>
      _$RandomFactsModelFromJson(json);
}
