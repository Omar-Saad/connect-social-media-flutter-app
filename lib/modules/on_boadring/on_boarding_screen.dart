import 'package:connect/modules/login/login_screen.dart';
import 'package:connect/shared/components/components.dart';
import 'package:connect/shared/network/local/cache_helper.dart';
import 'package:connect/shared/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  List<OnBoardingModel> onBoardingModels = [
    OnBoardingModel(
        'assets/images/on_boarding_1.png', 'Welcome to Connect', ''),
    OnBoardingModel('assets/images/on_boarding_2.png', 'Get Connected !',
        'Connect with your friends '),
    OnBoardingModel(
        'assets/images/on_boarding_3.png', 'Chat !', 'Chat with your friends '),
  ];

  var pageController = PageController();
  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: (){
            finishOnBoarding(context);

          }, child: Text('SKIP',)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) =>
                    buildOnBoardingItem(context, onBoardingModels[index]),
                itemCount: onBoardingModels.length,
                controller: pageController,
                physics: BouncingScrollPhysics(),
                onPageChanged: (value) {
                  if(value == onBoardingModels.length-1)
                    isLast = true;
                  else
                    isLast = false;
                  print(isLast);
                },
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(controller: pageController,
                  count: onBoardingModels.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: defaultColor,
                    dotWidth: 10.0,
                    dotHeight: 10.0,
                    expansionFactor: 4,

                  ),
                ),
                Spacer(),
                FloatingActionButton(onPressed: () {
                  if(isLast == true)
                    {
                      finishOnBoarding(context);
                    }
                  pageController.nextPage(
                    duration: Duration(
                      milliseconds: 750,
                    ), curve: Curves.fastLinearToSlowEaseIn,);
                },
                  child: Icon(Icons.arrow_forward_ios),),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnBoardingItem(context, OnBoardingModel model) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(model.image),
              width: double.infinity,
              // fit: BoxFit.cover,
            ),
          ),
          // RichText(
          //   text: TextSpan(
          //
          //       style: Theme.of(context)
          //           .textTheme
          //           .bodyText1
          //           .copyWith(fontSize: 30.0, fontWeight: FontWeight.normal),
          //       children: [
          //         if(model.title.contains('Connect'))
          //         TextSpan(
          //           text: 'Connect',
          //           style: Theme.of(context).textTheme.bodyText1.copyWith(
          //                 color: defaultColor,
          //                 fontSize: 30.0,
          //                 fontWeight: FontWeight.w700,
          //               ),
          //         )
          //       ]),
          // ),
          Text(
            model.title,
            style: Theme
                .of(context)
                .textTheme
                .bodyText1
                .copyWith(
              fontSize: 30.0,
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            model.description,
            style: Theme
                .of(context)
                .textTheme
                .bodyText1
                .copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      );

  void finishOnBoarding(context){
    CacheHelper.setData('isOnBoardingEnd', true).then((value) {
      if(value){
        navigateAndFinish(context, LoginScreen());
      }
    });
  }
}

class OnBoardingModel {
  final String image;
  final String title;
  final String description;

  OnBoardingModel(this.image, this.title, this.description);
}
