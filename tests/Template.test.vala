/**
* This is just a reference template, this always passes.
* If it doesn't, something has gone horribly wrong.
*/

public void always_passes(){
    assert (true);
}



public int main (string[] args){
    Test.init (ref args);

    Test.add_func ("/always_passes", always_passes);

    return Test.run ();
}