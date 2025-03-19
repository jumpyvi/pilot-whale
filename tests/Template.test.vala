/**
* This is just a template, this always passes
*/

public void always_passes(){
    assert (true);
}



public int main (string[] args){
    Test.init (ref args);

    Test.add_func ("/always_passes", always_passes);

    return Test.run ();
}