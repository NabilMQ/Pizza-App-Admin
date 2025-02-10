// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pizza_app_admin/src/components/macro.dart';
import 'package:pizza_app_admin/src/components/my_text_field.dart';
import 'package:pizza_app_admin/src/modules/create_pizza/blocs/create_pizza_bloc/create_pizza_bloc.dart';
import 'package:pizza_app_admin/src/modules/create_pizza/blocs/upload_photo_bloc/upload_photo_bloc.dart';
import 'package:pizza_repository/pizza_repository.dart';
import 'package:uuid/uuid.dart';

class CreatePizzaScreen extends StatefulWidget {
  const CreatePizzaScreen({super.key});

  @override
  State<CreatePizzaScreen> createState() => _CreatePizzaScreenState();
}

class _CreatePizzaScreenState extends State<CreatePizzaScreen> {

  late Pizza pizza;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final calorieController = TextEditingController();
  final proteinController = TextEditingController();
  final fatController = TextEditingController();
  final carbsController = TextEditingController();
  bool creationRequired = false;
	String? _errorMsg;

  @override
  void initState() {
    super.initState();
    pizza = Pizza.empty;
    pizza.pizzaId = Uuid().v1();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener <UploadPhotoBloc, UploadPhotoState>(
          listener: (context, state) {
            if (state is UploadPhotoSuccess) {
              setState(() {
                pizza.picture = "${dotenv.env["supabaseUrl"]!}/storage/v1/object/public/${state.url}";
              });
            }
          },
        ),
        BlocListener <CreatePizzaBloc, CreatePizzaState>(
          listener: (context, state) {
            if (state is CreatePizzaSuccess) {
              setState(() {
                creationRequired = false;
              });
              context.go('/');
            }
            else if (state is CreatePizzaProcess) {
              setState(() {
                creationRequired = true;   
              });
            }
          },
        )
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Create a New Pizza!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
      
                SizedBox(height: 20),
      
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  hoverColor: Colors.grey.shade300,
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxHeight: 1000,
                      maxWidth: 1000,
                    );
      
                    if (image != null && context.mounted) {
                      context.read<UploadPhotoBloc>()
                        .add(UploadPhoto(
                          await image.readAsBytes(),
                          image.name,
                        ));
                    }
                  },
                  child: pizza.picture.isNotEmpty 
                    ? Ink(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.network(
                        pizza.picture,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress != null) {
                            return Stack(
                              children: [
                                Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "${(loadingProgress.cumulativeBytesLoaded / 1000).toInt()}KB / ${(loadingProgress.expectedTotalBytes! / 1000).toInt()}KB",
                                    style: TextStyle(
                                      fontSize: 3,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return child;
                        },
                      ),
                    )
                    : Ink(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo,
                              size: 100,
                              color: Colors.grey.shade200,
                            ),
                                  
                            SizedBox(height: 10),
                                  
                            Text(
                              "Add a Picture here...",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
      
                SizedBox(height: 20),
      
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
      
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: MyTextField(
                          controller: nameController,
                          hintText: 'Name',
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.abc),
                          errorMsg: _errorMsg,
                          // ignore: duplicate_ignore
                          // ignore: body_might_complete_normally_nullable
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please fill in this field';
                            }
                          }
                        )
                      ),
      
                      SizedBox(height: 10),
      
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: MyTextField(
                          controller: descriptionController,
                          hintText: 'Description',
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.description),
                          errorMsg: _errorMsg,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please fill in this field';
                            }
                          }
                        )
                      ),
      
                      SizedBox(height: 10),
      
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: MyTextField(
                                controller: priceController,
                                hintText: 'Price',
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(Icons.monetization_on),
                                errorMsg: _errorMsg,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  }
                                }
                              )
                            ),
                          ),
      
                          SizedBox(width: 10),
      
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: MyTextField(
                                controller: discountController,
                                hintText: 'Discount',
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(Icons.percent),
                                errorMsg: _errorMsg,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  }
                                }
                              )
                            ),
                          ),
                        ],
                      ),
      
                      SizedBox(height: 10),
      
                      Row(
                        children: [
                          Text(
                            "is Vege"
                          ),
                          Checkbox(
                            value: pizza.isVeg,
                            onChanged: (value) {
                              setState(() {
                                pizza.isVeg = value!;
                              });
                            },
                          ),
      
                          SizedBox(width: 50),
                          
                          Text(
                            "is Spicy"
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                pizza.spicy = 0;
                              });
                            },
                            borderRadius: BorderRadius.circular(9999),
                            child: Ink(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: pizza.spicy == 0 
                                  ? Border.all(
                                    width: 2,
                                  )
                                  : null,
                                color: pizza.spicy == 0
                                  ? Colors.green
                                  : Colors.green.shade200,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                pizza.spicy = 1;
                              });
                            },
                            borderRadius: BorderRadius.circular(9999),
                            child: Ink(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: pizza.spicy == 1
                                  ? Border.all(
                                    width: 2,
                                  )
                                  : null,
                                color: pizza.spicy == 1
                                  ? Colors.orange
                                  : Colors.orange.shade200,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                pizza.spicy = 2;
                              });
                            },
                            borderRadius: BorderRadius.circular(9999),
                            child: Ink(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: pizza.spicy == 2
                                  ? Border.all(
                                    width: 2,
                                  )
                                  : null,
                                color: pizza.spicy == 2
                                  ? Colors.red
                                  : Colors.red.shade200,
                              ),
                            ),
                          ),
                        ],
                      ),
      
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Macros",
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          MyMacroWidget(
                            controller: calorieController,
                            value: 12,
                            title: "Calories",
                            icon: FontAwesomeIcons.fire,
                          ), 
                          SizedBox(width: 10),
                          MyMacroWidget(
                            controller: proteinController,
                            value: 12,
                            title: "Protein",
                            icon: FontAwesomeIcons.dumbbell,
                          ),
                          SizedBox(width: 10),
                          MyMacroWidget(
                            controller: fatController,
                            value: 12,
                            title: "Fat",
                            icon: FontAwesomeIcons.oilWell,
                          ), 
                          SizedBox(width: 10),
                          MyMacroWidget(
                            controller: carbsController,
                            value: 12,
                            title: "Carbs",
                            icon: FontAwesomeIcons.breadSlice,
                          ), 
                        ],
                      ),
      
                      const SizedBox(height: 20),
      
                      !creationRequired
                        ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              pizza.name = nameController.text;
                              pizza.description = descriptionController.text;
                              pizza.price = int.parse(priceController.text);
                              pizza.discount = int.parse(discountController.text);
                              pizza.macros.calories = int.parse(calorieController.text);
                              pizza.macros.carbs = int.parse(carbsController.text);
                              pizza.macros.proteins = int.parse(proteinController.text);
                              pizza.macros.fat = int.parse(fatController.text);
                            });
                            context.read<CreatePizzaBloc>().add(CreatePizza(pizza));
                          },
                          style: TextButton.styleFrom(
                            elevation: 3.0,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60)
                            )
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                            child: Text(
                              'Create Pizza',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          )
                        ),
                      )
                      : const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}