class Pokemon {
  const Pokemon({
    required this.id,
    required this.name,
    required this.locationAreaEncounters,
    required this.baseExperience,
    required this.height,
    required this.weight,
    required this.order,
    required this.isDefault,
    required this.species,
    required this.sprites,
    required this.abilities,
    required this.forms,
    required this.types,
  });

  final int id;
  final String name;
  final String locationAreaEncounters;
  final int baseExperience;
  final int height;
  final int weight;
  final int order;
  final bool isDefault;
  final Species species;
  final Sprites sprites;
  final List<Ability> abilities;
  final List<Form> forms;
  final List<Type> types;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      locationAreaEncounters: json['location_area_encounters'],
      baseExperience: json['base_experience'],
      height: json['height'],
      weight: json['weight'],
      order: json['order'],
      isDefault: json['is_default'],
      species: Species.fromJson(json['species']),
      sprites: Sprites.fromJson(json['sprites']),
      abilities: List<Ability>.from(
        json['abilities'].map((x) => Ability.fromJson(x)),
      ),
      forms: List<Form>.from(
        json['forms'].map((x) => Form.fromJson(x)),
      ),
      types: List<Type>.from(
        json['types'].map((x) => Type.fromJson(x)),
      ),
    );
  }
}

class Ability {
  const Ability({
    required this.ability,
    required this.isHidden,
    required this.slot,
  });

  final AbilityDetail ability;
  final bool isHidden;
  final int slot;

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      ability: AbilityDetail.fromJson(json['ability']),
      isHidden: json['is_hidden'],
      slot: json['slot'],
    );
  }
}

class AbilityDetail {
  const AbilityDetail({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  factory AbilityDetail.fromJson(Map<String, dynamic> json) {
    return AbilityDetail(
      name: json['name'],
      url: json['url'],
    );
  }
}

class Form {
  const Form({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  factory Form.fromJson(Map<String, dynamic> json) {
    return Form(
      name: json['name'],
      url: json['url'],
    );
  }
}

class Species {
  const Species({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      name: json['name'],
      url: json['url'],
    );
  }
}

class Sprites {
  const Sprites({
    required this.backDefault,
    required this.backFemale,
    required this.backShiny,
    required this.backShinyFemale,
    required this.frontDefault,
    required this.frontFemale,
    required this.frontShiny,
    required this.frontShinyFemale,
    required this.other,
  });

  final String backDefault;
  final String? backFemale;
  final String backShiny;
  final String? backShinyFemale;
  final String frontDefault;
  final String? frontFemale;
  final String frontShiny;
  final String? frontShinyFemale;
  final OtherSprites other;

  factory Sprites.fromJson(Map<String, dynamic> json) {
    return Sprites(
      backDefault: json['back_default'],
      backFemale: json['back_female'],
      backShiny: json['back_shiny'],
      backShinyFemale: json['back_shiny_female'],
      frontDefault: json['front_default'],
      frontFemale: json['front_female'],
      frontShiny: json['front_shiny'],
      frontShinyFemale: json['front_shiny_female'],
      other: OtherSprites.fromJson(json['other']),
    );
  }
}

class OtherSprites {
  const OtherSprites({
    required this.dreamWorld,
    required this.home,
    required this.officialArtwork,
    required this.showdown,
  });

  final DreamWorld dreamWorld;
  final Home home;
  final OfficialArtwork officialArtwork;
  final Showdown showdown;

  factory OtherSprites.fromJson(Map<String, dynamic> json) {
    return OtherSprites(
      dreamWorld: DreamWorld.fromJson(json['dream_world']),
      home: Home.fromJson(json['home']),
      officialArtwork: OfficialArtwork.fromJson(json['official-artwork']),
      showdown: Showdown.fromJson(json['showdown']),
    );
  }
}

class DreamWorld {
  const DreamWorld({
    required this.frontDefault,
    required this.frontFemale,
  });

  final String frontDefault;
  final String? frontFemale;

  factory DreamWorld.fromJson(Map<String, dynamic> json) {
    return DreamWorld(
      frontDefault: json['front_default'],
      frontFemale: json['front_female'],
    );
  }
}

class Home {
  const Home({
    required this.frontDefault,
    required this.frontFemale,
    required this.frontShiny,
    required this.frontShinyFemale,
  });

  final String frontDefault;
  final String? frontFemale;
  final String frontShiny;
  final String? frontShinyFemale;

  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
      frontDefault: json['front_default'],
      frontFemale: json['front_female'],
      frontShiny: json['front_shiny'],
      frontShinyFemale: json['front_shiny_female'],
    );
  }
}

class OfficialArtwork {
  const OfficialArtwork({
    required this.frontDefault,
    required this.frontShiny,
  });

  final String frontDefault;
  final String frontShiny;

  factory OfficialArtwork.fromJson(Map<String, dynamic> json) {
    return OfficialArtwork(
      frontDefault: json['front_default'],
      frontShiny: json['front_shiny'],
    );
  }
}

class Showdown {
  const Showdown({
    required this.backDefault,
    required this.backFemale,
    required this.backShiny,
    required this.backShinyFemale,
    required this.frontDefault,
    required this.frontFemale,
    required this.frontShiny,
    required this.frontShinyFemale,
  });

  final String backDefault;
  final String? backFemale;
  final String backShiny;
  final String? backShinyFemale;
  final String frontDefault;
  final String? frontFemale;
  final String frontShiny;
  final String? frontShinyFemale;

  factory Showdown.fromJson(Map<String, dynamic> json) {
    return Showdown(
      backDefault: json['back_default'],
      backFemale: json['back_female'],
      backShiny: json['back_shiny'],
      backShinyFemale: json['back_shiny_female'],
      frontDefault: json['front_default'],
      frontFemale: json['front_female'],
      frontShiny: json['front_shiny'],
      frontShinyFemale: json['front_shiny_female'],
    );
  }
}

class Type {
  const Type({
    required this.slot,
    required this.type,
  });

  final int slot;
  final TypeDetail type;

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      slot: json['slot'],
      type: TypeDetail.fromJson(json['type']),
    );
  }
}

class TypeDetail {
  const TypeDetail({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  factory TypeDetail.fromJson(Map<String, dynamic> json) {
    return TypeDetail(
      name: json['name'],
      url: json['url'],
    );
  }
}
