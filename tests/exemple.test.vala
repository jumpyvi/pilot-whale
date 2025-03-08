

public void test_one(){
    assert (true);
}

public void test_two(){
    assert (true == true);
}

public void test_three(){
    assert (true == true);
}



public int main (string[] args){
    Test.init (ref args);

    Test.add_func ("/test_one", test_one);
    Test.add_func ("/test_two", test_two);
    Test.add_func ("/test_three", test_three);

    return Test.run ();
}