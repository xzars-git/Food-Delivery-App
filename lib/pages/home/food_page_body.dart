import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:food_delivery_app/controllers/popular_product_controller.dart';
import 'package:food_delivery_app/data/repository/popular_product_repo.dart';
import 'package:food_delivery_app/pages/food/favorite_food_detail.dart';
import 'package:food_delivery_app/routes/routes_helper.dart';
import 'package:food_delivery_app/utils/app_colors.dart';
import 'package:food_delivery_app/utils/app_constanst.dart';
import 'package:food_delivery_app/widgets/big_text.dart';
import 'package:food_delivery_app/widgets/icons_text_widget.dart';
import 'package:food_delivery_app/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:food_delivery_app/controllers/recommended_product_controller.dart';
import 'package:food_delivery_app/data/repository/recommended_product_repo.dart';
import '../../utils/dimensions.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currentPageValue = 0.0;
  var _scaleFactor = 0.8;
  var _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //Slider Section
      GetBuilder<PopularProductController>(builder: (popularProducts) {
        return popularProducts.isLoaded
            ? Container(
                height: Dimensions.pageView,
                child: PageView.builder(
                    controller: pageController,
                    itemCount: popularProducts.popularProductList.length,
                    itemBuilder: (context, position) {
                      return _buildPageItem(position,
                          popularProducts.popularProductList[position]);
                    }),
              )
            : CircularProgressIndicator(
                color: AppColor.mainColor,
              );
      }),
      //Dots Indicator
      GetBuilder<PopularProductController>(builder: (popularProducts) {
        return new DotsIndicator(
          dotsCount: popularProducts.popularProductList.isEmpty
              ? 1
              : popularProducts.popularProductList.length,
          position: _currentPageValue,
          decorator: DotsDecorator(
            activeColor: AppColor.mainColor,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        );
      }),
      //Popular Text
      SizedBox(
        height: Dimensions.height30,
      ),

      Container(
        margin: EdgeInsets.only(left: Dimensions.width30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BigText(text: "Recommended"),
            SizedBox(
              width: Dimensions.width10,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 3),
              child: BigText(
                text: ".",
                color: Colors.black26,
              ),
            ),
            SizedBox(
              width: Dimensions.width10,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 2),
              child: SmallText(text: "Food Pairing"),
            )
          ],
        ),
      ),
      //List of Food and Images
      GetBuilder<RecommendedProductController>(builder: (recommendedProduct) {
        return recommendedProduct.isLoaded
            ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: recommendedProduct.recommendedProductList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.getRecommendedFood(index));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                          bottom: Dimensions.height10),
                      child: Row(children: [
                        Container(
                          height: Dimensions.listViewImgSize,
                          width: Dimensions.listViewImgSize,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius20),
                              color: Colors.white38,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(AppConstants.BASE_URL +
                                      AppConstants.UPLOAD_URL +
                                      recommendedProduct
                                          .recommendedProductList[index]
                                          .img!))),
                        ),
                        //Text Container
                        Expanded(
                          child: Container(
                            height: Dimensions.listViewTextContSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(Dimensions.radius20),
                                bottomRight:
                                    Radius.circular(Dimensions.radius20),
                              ),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: Dimensions.width10,
                                  right: Dimensions.width10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BigText(
                                      text: recommendedProduct
                                          .recommendedProductList[index].name!),
                                  SizedBox(
                                    height: Dimensions.height10,
                                  ),
                                  SmallText(
                                      text: recommendedProduct
                                          .recommendedProductList[index]
                                          .description!),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconAndTextWidget(
                                        icon: Icons.circle_sharp,
                                        text: "Normal",
                                        iconColor: AppColor.iconColor1,
                                        sizedBox: 2,
                                      ),
                                      IconAndTextWidget(
                                          icon: Icons.location_on,
                                          text: "1.8km",
                                          sizedBox: 2,
                                          iconColor: AppColor.mainColor),
                                      IconAndTextWidget(
                                          icon: Icons.access_time_rounded,
                                          text: "32min",
                                          sizedBox: 1.5,
                                          iconColor: AppColor.iconColor2)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                  );
                })
            : CircularProgressIndicator(
                color: AppColor.mainColor,
              );
      })
      //
    ]);
  }

  Widget _buildPageItem(int index, popularProduct) {
    Matrix4 matrix = new Matrix4.identity();
    if (index == _currentPageValue.floor()) {
      var currScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currentPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currentPageValue - index + 1) * (1 - _scaleFactor);

      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);

      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currentPageValue.floor() - 1) {
      var currScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);

      var currTrans = _height * (1 - currScale) / 2;

      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;

      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }
    return Transform(
      transform: matrix,
      child: Stack(children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(RouteHelper.getPopularFood(index));
          },
          child: Container(
            height: 220,
            margin: EdgeInsets.only(
                left: Dimensions.width10, right: Dimensions.width10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294cc),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(AppConstants.BASE_URL +
                        AppConstants.UPLOAD_URL +
                        popularProduct.img!))),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: Dimensions.pageViewTextContainer,
            margin: EdgeInsets.only(
                left: Dimensions.width30,
                right: Dimensions.width30,
                bottom: Dimensions.height30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFFe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(0, 5)),
                  BoxShadow(color: Colors.white, offset: Offset(-5, 0)),
                  BoxShadow(color: Colors.white, offset: Offset(5, 0)),
                ]),
            child: Container(
              padding: EdgeInsets.only(
                  top: Dimensions.height15,
                  left: Dimensions.width15,
                  right: Dimensions.width15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BigText(text: popularProduct.name!),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  Row(
                    children: [
                      Wrap(
                          children: List.generate(
                              5,
                              (index) => Icon(Icons.star,
                                  color: AppColor.mainColor, size: 15))),
                      SizedBox(
                        width: 5,
                      ),
                      SmallText(text: "4.5"),
                      SizedBox(
                        width: 5,
                      ),
                      SmallText(text: "1234"),
                      SizedBox(
                        width: 5,
                      ),
                      SmallText(text: "comments"),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconAndTextWidget(
                          icon: Icons.circle_sharp,
                          text: "Normal",
                          sizedBox: 5,
                          iconColor: AppColor.iconColor1),
                      IconAndTextWidget(
                          icon: Icons.location_on,
                          text: "1.8km",
                          sizedBox: 5,
                          iconColor: AppColor.mainColor),
                      IconAndTextWidget(
                          icon: Icons.access_time_rounded,
                          text: "32min",
                          sizedBox: 5,
                          iconColor: AppColor.iconColor2)
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
