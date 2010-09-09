public class GeologDeviceID {
	String id;
	/**
		Validate that the input conforms with the ID specifications
	**/
	public GeologDeviceID(String s){
		//TODO: Test validity before assignment and throw an exception if invalid
		id=s;
	}

	/**
		Check whether the supplied string is a valid id
	**/
	public static boolean isValidID(String s){
		//TODO: Do a regex pattern matching test on the supplied string
		return true;
	}
}