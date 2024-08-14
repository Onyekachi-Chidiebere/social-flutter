  Positioned(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        minLines: 1,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: "What's on your mind?", // Placeholder text
                          contentPadding: EdgeInsets.all(10.0), // Reduce height
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(20.0), // Rounded corners
                            borderSide: BorderSide(
                              color: Colors.grey, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Rounded corners when focused
                            borderSide: BorderSide(
                              color: Colors.orange, // Border color when focused
                              width: 1.0, // Border width
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
       