// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 0;

  @override
  Recipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipe(
      title: fields[0] as String,
      description: fields[1] as String,
      cookingTime: fields[2] as int,
      type: fields[3] as String,
      category: fields[4] as String,
      ingredients: (fields[5] as List).cast<String>(),
      steps: (fields[6] as List).cast<String>(),
      imagePath: fields[7] as String,
      isBookmarked: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.cookingTime)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.ingredients)
      ..writeByte(6)
      ..write(obj.steps)
      ..writeByte(7)
      ..write(obj.imagePath)
      ..writeByte(8)
      ..write(obj.isBookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShoppingItemAdapter extends TypeAdapter<ShoppingItem> {
  @override
  final int typeId = 1;

  @override
  ShoppingItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoppingItem(
      name: fields[0] as String,
      category: fields[1] as String,
      isPurchased: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ShoppingItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.isPurchased);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealPlanAdapter extends TypeAdapter<MealPlan> {
  @override
  final int typeId = 33;

  @override
  MealPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealPlan(
      mealName: fields[0] as String,
      category: fields[1] as String,
      notes: fields[2] as String,
      date: fields[3] as String,
      meals: (fields[4] as List).cast<String>(),
      time: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MealPlan obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.mealName)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.meals)
      ..writeByte(5)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecipeFixAdapter extends TypeAdapter<RecipeFix> {
  @override
  final int typeId = 2;

  @override
  RecipeFix read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeFix(
      title: fields[0] as String,
      description: fields[1] as String,
      imageUrl: fields[2] as String,
      cookingTime: fields[3] as int,
      type: fields[4] as String,
      category: fields[5] as String,
      ingredients: (fields[6] as List).cast<String>(),
      steps: (fields[7] as List).cast<String>(),
      isBookmarked: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeFix obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.cookingTime)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.ingredients)
      ..writeByte(7)
      ..write(obj.steps)
      ..writeByte(8)
      ..write(obj.isBookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeFixAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
