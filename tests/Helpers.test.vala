public void test_clean_image_name(){
    string name = " hello&world+=";
    string expected = "helloworld";
    string result = Utilities.clean_image_name(name);
    print(result + "\n");

    assert(result == expected);
}


public int main(string[] args) {
    Test.init(ref args);

    Test.add_func("/test_clean_image_name", test_clean_image_name);

    return Test.run();
}