

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pizza_repository/pizza_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirebasePizzaRepo implements PizzaRepo {
    final pizzasCollection = FirebaseFirestore.instance.collection('pizzas');

    @override
    Future <List <Pizza>> getPizzas() async {
      try {
        return await pizzasCollection
          .get()
          .then((value) => value.docs.map((e) => 
            Pizza.fromEntity(PizzaEntity.fromDocument(e.data()))
          ).toList());
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    } 

    @override
    Future <String> sendImage(Uint8List file, String name) async {
      try {
        // final reader = html.FileReader();
        // reader.readAsArrayBuffer(file);
        // await reader.onLoad.first;
        // final pizzaImage = reader.result as Uint8List;
        final String fullPath = await Supabase.instance.client.storage.from('Pizzas Photo').uploadBinary(
          'public/$name',
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
        debugPrint(fullPath);
        return fullPath;
      }
      catch (e) {
        debugPrint(e.toString());
        rethrow;
      }
    }

    @override
    Future <void> createPizza(Pizza pizza) async {
      try {
        return await pizzasCollection
          .doc(pizza.pizzaId)
          .set(pizza.toEntity().toDocument());
      }
      catch (e) {
        debugPrint(e.toString());
        rethrow;
      }
    }
}