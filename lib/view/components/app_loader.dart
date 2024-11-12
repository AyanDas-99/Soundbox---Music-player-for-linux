import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:split_view/split_view.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    SplitViewController controller = SplitViewController(
      weights: [0.2, 0.8],
      limits: [WeightLimit(max: 0.4, min: 0.2)],
    );

    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: screenWidth < 700
            ? Builder(builder: (context) {
                return IconButton(
                  iconSize: 15,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                );
              })
            : null,
        backgroundColor: Colors.grey.shade900,
        iconTheme: const IconThemeData(color: Colors.grey),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: (screenWidth > 700)
                    ? SplitView(
                        controller: controller,
                        viewMode: SplitViewMode.Horizontal,
                        gripColor: Colors.blueGrey.shade900,
                        gripColorActive: Colors.grey.shade900,
                        gripSize: 7,
                        children: [
                          Container(
                            color: Colors.blueGrey.shade800,
                            child: ListView(
                                children: List.generate(
                                    6,
                                    (index) => Shimmer.fromColors(
                                        baseColor: Colors.blueGrey.shade900,
                                        highlightColor:
                                            Colors.blueGrey.shade800,
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          margin: const EdgeInsets.all(10),
                                        )))),
                          ),
                          Container(
                            color: Colors.blueGrey.shade900,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 50),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Current Playlist",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.blueGrey.shade900,
                                        highlightColor:
                                            Colors.blueGrey.shade800,
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  ...List.generate(
                                      5,
                                      (index) => Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              children: [
                                                Shimmer.fromColors(
                                                  baseColor:
                                                      Colors.blueGrey.shade900,
                                                  highlightColor:
                                                      Colors.blueGrey.shade800,
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                Shimmer.fromColors(
                                                  baseColor:
                                                      Colors.blueGrey.shade900,
                                                  highlightColor:
                                                      Colors.blueGrey.shade800,
                                                  child: Container(
                                                    height: 40,
                                                    width: 300,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Shimmer.fromColors(
                                                  baseColor:
                                                      Colors.blueGrey.shade900,
                                                  highlightColor:
                                                      Colors.blueGrey.shade800,
                                                  child: Container(
                                                    height: 40,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        color: Colors.blueGrey.shade900,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Current Playlist",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.blueGrey.shade900,
                                    highlightColor: Colors.blueGrey.shade800,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15),
                              ...List.generate(
                                  5,
                                  (index) => Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          children: [
                                            Shimmer.fromColors(
                                              baseColor:
                                                  Colors.blueGrey.shade900,
                                              highlightColor:
                                                  Colors.blueGrey.shade800,
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Shimmer.fromColors(
                                              baseColor:
                                                  Colors.blueGrey.shade900,
                                              highlightColor:
                                                  Colors.blueGrey.shade800,
                                              child: Container(
                                                height: 40,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Shimmer.fromColors(
                                              baseColor:
                                                  Colors.blueGrey.shade900,
                                              highlightColor:
                                                  Colors.blueGrey.shade800,
                                              child: Container(
                                                height: 40,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                            ],
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              Shimmer.fromColors(
                baseColor: Colors.blueGrey.shade900,
                highlightColor: Colors.blueGrey.shade800,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Colors.blueGrey.shade800,
                      Colors.grey.shade900,
                    ],
                  )),
                  height: 120,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
