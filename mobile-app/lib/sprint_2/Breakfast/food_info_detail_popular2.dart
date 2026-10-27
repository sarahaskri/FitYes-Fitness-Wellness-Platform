import 'package:fityes/sprint_2/colo_extension.dart';
import 'package:fityes/sprint_2/round_boutton.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:fityes/sprint_2/food_step_detail.dart';
import 'package:fityes/sprint_2/addMeal.dart';

class FoodInfoDetailsView2 extends StatefulWidget {
  final Map mObj;
  final Map dObj;
  const FoodInfoDetailsView2(
      {super.key, required this.dObj, required this.mObj});

  @override
  State<FoodInfoDetailsView2> createState() => _FoodInfoDetailsViewState2();
}

class _FoodInfoDetailsViewState2 extends State<FoodInfoDetailsView2> {
  List nutritionArr = [
    {"image": "assets/images/burn.png", "title": "210kCal"},
    {"image": "assets/images/egg.png", "title": "18g fats"},
    {"image": "assets/images/proteins.png", "title": "14g proteins"},
    {"image": "assets/images/carbo.png", "title": "2g carbs"},
  ];

  List ingredientsArr = [
    {"image": "assets/images/eggs.png", "title": "Eggs", "value": "3 items"},
    {"image": "assets/images/basil.png", "title": "Fresh Basil", "value": "5 leaves"},
    {"image": "assets/images/milk.png", "title": "Milk", "value": "2 tbsp"},
    {"image": "assets/images/oil.png", "title": "Olive Oil", "value": "1 tbsp"},
    {"image": "assets/images/salt.png", "title": "Salt", "value": "To taste"},
    {"image": "assets/images/pepper.png", "title": "Pepper", "value": "To taste"},
  ];

  List stepArr = [
    {"no": "1", "detail": "Crack the eggs into a bowl and add milk, salt, and pepper."},
    {"no": "2", "detail": "Whisk the mixture until smooth and frothy."},
    {"no": "3", "detail": "Heat olive oil in a non-stick pan over medium heat."},
    {"no": "4", "detail": "Pour the egg mixture into the pan and cook for 2 minutes."},
    {"no": "5", "detail": "Add chopped fresh basil evenly over the eggs."},
    {"no": "6", "detail": "Fold the omelette gently and cook another minute."},
    {"no": "7", "detail": "Serve hot with a side of toast or salad."},
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: TColor.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset("assets/images/black_btn.png", width: 15, height: 15),
                ),
              ),
          
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: Container(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: ClipRect(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Transform.scale(
                      scale: 1.25,
                      child: Container(
                        width: media.width * 0.55,
                        height: media.width * 0.55,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(media.width * 0.275),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 1.25,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          widget.dObj["b_image"].toString(),
                          width: media.width * 0.50,
                          height: media.width * 0.50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 50,
                          height: 4,
                          decoration: BoxDecoration(
                            color: TColor.gray.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.dObj["name"].toString(),
                                    style: TextStyle(
                                        color: TColor.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text("by FitYes Chef",
                                      style: TextStyle(
                                          color: TColor.gray, fontSize: 12)),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Image.asset("assets/images/fav.png", width: 15, height: 15),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text("Nutrition",
                            style: TextStyle(
                                color: TColor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                      ),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          scrollDirection: Axis.horizontal,
                          itemCount: nutritionArr.length,
                          itemBuilder: (context, index) {
                            var nObj = nutritionArr[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    TColor.primaryColor2.withOpacity(0.4),
                                    TColor.primaryColor1.withOpacity(0.4),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(nObj["image"], width: 15, height: 15),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(nObj["title"],
                                        style: TextStyle(
                                            color: TColor.black, fontSize: 12)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text("Description",
                            style: TextStyle(
                                color: TColor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ReadMoreText(
                          'A delicious and healthy basil omelette made with fresh eggs, basil leaves, and olive oil. Perfect for a quick breakfast or brunch that’s rich in flavor and protein.',
                          trimLines: 4,
                          colorClickableText: TColor.black,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' Read More...',
                          trimExpandedText: ' Read Less',
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                          moreStyle: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Ingredients That You\nWill Need",
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            TextButton(
                              onPressed: () {},
                              child: Text("${ingredientsArr.length} Items",
                                  style:
                                      TextStyle(color: TColor.gray, fontSize: 12)),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: (media.width * 0.25) + 40,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          scrollDirection: Axis.horizontal,
                          itemCount: ingredientsArr.length,
                          itemBuilder: (context, index) {
                            var item = ingredientsArr[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: media.width * 0.23,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: media.width * 0.23,
                                    height: media.width * 0.23,
                                    decoration: BoxDecoration(
                                        color: TColor.lightGray,
                                        borderRadius: BorderRadius.circular(10)),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      item["image"],
                                      width: 45,
                                      height: 45,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(item["title"],
                                      style: TextStyle(
                                          color: TColor.black, fontSize: 12)),
                                  Text(item["value"],
                                      style: TextStyle(
                                          color: TColor.gray, fontSize: 10)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Step by Step",
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            TextButton(
                              onPressed: () {},
                              child: Text("${stepArr.length} Steps",
                                  style:
                                      TextStyle(color: TColor.gray, fontSize: 12)),
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        shrinkWrap: true,
                        itemCount: stepArr.length,
                        itemBuilder: (context, index) {
                          var sObj = stepArr[index];
                          return FoodStepDetailRow(
                            sObj: sObj,
                            isLast: stepArr.last == sObj,
                          );
                        },
                      ),
                      SizedBox(height: media.width * 0.25),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: RoundButton(
                          title: "Add to ${widget.mObj["name"]} Meal",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddMealPage(
                                          mealName:
                                              widget.dObj["name"].toString(),
                                          mealType:
                                              widget.mObj["name"].toString(),
                                             imagepath: widget.dObj["b_image"].toString(),
                                        )));
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
