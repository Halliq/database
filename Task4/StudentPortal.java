import java.sql.*; // JDBC stuff.
import java.io.*;  // Reading user input.

public class StudentPortal
{
	/* This is the driving engine of the program. It parses the
	 * command-line arguments and calls the appropriate methods in
	 * the other classes.
	 *
	 * You should edit this file in two ways:
	 * 	1) 	Insert your database username and password (no @medic1!)
	 *		in the proper places.
	 *	2)	Implement the three functions getInformation, registerStudent
	 *		and unregisterStudent.
	 */
	public static void main(String[] args)
	{
		if (args.length == 1) {
			try {
				DriverManager.registerDriver(new oracle.jdbc.OracleDriver());
				String url = "jdbc:oracle:thin:@tycho.ita.chalmers.se:1521/kingu.ita.chalmers.se";
				String userName = "htda357_000"; // Your username goes here!
				String password = "htda357_000"; // Your password goes here!
				Connection conn = DriverManager.getConnection(url,userName,password);

				String student = null; // This ius the identifier for the student.
				BufferedReader input = new BufferedReader(new InputStreamReader(System.in));
				System.out.println("Welcome!");
				while(true) {
					System.out.println("Please choose a mode of operation:");
					System.out.print("? > ");
					String mode = input.readLine();
					if ((new String("information")).startsWith(mode.toLowerCase())) {
						/* Information mode */
						System.out.print("Student ID? > ");
						student = input.readLine();
						getInformation(conn, student);
					} else if ((new String("register")).startsWith(mode.toLowerCase())) {
						/* Register student mode */
						System.out.print("Student ID? > ");
						student = input.readLine();
						System.out.print("Register for what course? > ");
						String course = input.readLine();
						registerStudent(conn, student, course);
					} else if ((new String("unregister")).startsWith(mode.toLowerCase())) {
						/* Unregister student mode */
						System.out.print("Student ID? > ");
						student = input.readLine();
						System.out.print("Unregister from what course? > ");
						String course = input.readLine();
						unregisterStudent(conn, student, course);
					} else if ((new String("quit")).startsWith(mode.toLowerCase())) {
						System.out.println("Goodbye!");
						break;
					} else {
						System.out.println("Unknown argument, please choose either " +
									 "information, register, unregister or quit!");
						continue;
					}
				}
				conn.close();
			} catch (SQLException e) {
				System.err.println(e);
				System.exit(2);
			} catch (IOException e) {
				System.err.println(e);
				System.exit(2);
			}
		} else {
			System.err.println("Wrong number of arguments");
			System.exit(3);
		}
	}

	static void getInformation(Connection conn, String student) throws SQLException
	{
		String studentSelection = "SELECT *" +
								  " FROM student " +
								  " WHERE id = '" + student+"'";
		Statement myStmt = conn.createStatement();
		ResultSet rs = myStmt.executeQuery(studentSelection);
		while(rs.next())
		{
			System.out.println("----------------Student Information------------------");
			String id=rs.getString(1);
			String name=rs.getString(2);
			String program=rs.getString(3);
			String branch=rs.getString(4);
			System.out.println("ID:" +id);
			System.out.println("Name:" +name);
			System.out.println("Program:" +program);
			System.out.println("Branch:" +branch);
		}
		
		String passedcourse = "SELECT *" +
				  " FROM PassedCourses " +
				  " WHERE id = '" + student+"'";
		Statement myStmt2 = conn.createStatement();
		ResultSet rs2 = myStmt2.executeQuery(passedcourse);
		while(rs2.next())
		{
			System.out.println("----------------  Passed Course  ------------------");
			String courseCode=rs2.getString(3);
			String courseName=rs2.getString(4);
			String grade=rs2.getString(5);
			System.out.println("Course Code:" +courseCode);
			System.out.println("Course Name:" +courseName);
			System.out.println("Grade:" +grade);
		}
		
		String courseInvolved = "SELECT *" +
				  " FROM registrations " +
				  " WHERE id = '" + student+"'";
		Statement myStmt3 = conn.createStatement();
		ResultSet rs3 = myStmt3.executeQuery(courseInvolved);
		while(rs3.next())
		{
			System.out.println("----------------  Involved Course  ------------------");
			String courseCode=rs3.getString(2);
			String registerStatus=rs3.getString(3);
			System.out.println("Course Code: " +courseCode);
			System.out.println("Register Status: " +registerStatus);
			// if waiting, show waiting number
			if(registerStatus.equals("waiting")){
				String waitingnumber = "SELECT * FROM courseQueuePositions WHERE id = '" + student +"' AND code ='" + courseCode +"'";
				Statement myStmt4 = conn.createStatement();
				ResultSet rs4 = myStmt4.executeQuery(waitingnumber);
				if(rs4.next())
				{
					int position=rs4.getInt(3);
					System.out.println("The waiting position is: " +position);
				}	
			}// end of if waiting
		}
		
		String studentGraduation = "SELECT *" +
				  " FROM  PathToGraduation " +
				  " WHERE student = '" + student+"'";
		Statement myStmt1 = conn.createStatement();
		ResultSet rs1 = myStmt1.executeQuery(studentGraduation);
		while(rs1.next())
		{
			System.out.println("----------------Student Graduation------------------");
			int seminar=rs1.getInt(7);
			int math=rs1.getInt(5);
			int research=rs1.getInt(6);
			int passed=rs1.getInt(2);
			String graduation=rs1.getString(8);
			System.out.println("Seminar courses taken:" +seminar);
			System.out.println("Math credits taken: " +math);
			System.out.println("Research credits taken:" +research);
			System.out.println("Total passed credits:" +passed);
			System.out.println("Graduation:" +graduation);
		}
		
	}

	static void registerStudent(Connection conn, String student, String course) throws SQLException
	{
		try{
			Statement myStmt = conn.createStatement();
			Statement myStmt1 = conn.createStatement();
			Statement myStmt2 = conn.createStatement();
			
			String studentRegister = "INSERT INTO Registrations(id, code) VALUES ('" + student +"','"+ course +"')";
			int linesChanged = myStmt.executeUpdate(studentRegister);
			String registerStatus = null;
			// check if one row has been inserted
			if (linesChanged >0){   
				// check the status of registration
				String registration = "SELECT * FROM registrations WHERE id = '" + student +"' AND code ='" + course +"'";
				ResultSet rs1 = myStmt1.executeQuery(registration);
				while(rs1.next())
				{ 
					String id=rs1.getString(1);
					String courseName=rs1.getString(2);
					registerStatus=rs1.getString(3);
					System.out.println("Student ID:" +id);
					System.out.println("Course:" +courseName);
					System.out.println("Register Status:" +registerStatus);					
				}
				String wait = "waiting";
				String reg = "registered";
				// if register
				if(registerStatus.equals(reg)){
					System.out.println("The student "+ student +" is successfully registered to course "+ course +"!");
				}
				// if waiting, show waiting number
				if(registerStatus.equals(wait)){
					String waitingnumber = "SELECT * FROM courseQueuePositions WHERE id = '" + student +"' AND code ='" + course +"'";
					ResultSet rs2 = myStmt2.executeQuery(waitingnumber);
					if(rs2.next())
					{
						int position=rs2.getInt(3);
						System.out.println("The position is: " +position);
					}	
				}// end of if waiting
			}// end of if line has been inserted		
		} // end of try
		catch(SQLException e){
			String errorMessage = e.getMessage();
			System.out.println(errorMessage);
		}
		
		

	}

	static void unregisterStudent(Connection conn, String student, String course) throws SQLException
	{
		try{
			Statement myStmt = conn.createStatement();
			Statement myStmt1 = conn.createStatement();
			String registerStatus=null;
			String wait = "waiting";
			String reg = "registered";
			
			// check the status of registration
			String registration = "SELECT * FROM registrations WHERE id = '" + student +"' AND code ='" + course +"'";
			ResultSet rs1 = myStmt1.executeQuery(registration);
			while(rs1.next())
			{ 
				registerStatus=rs1.getString(3);
				System.out.println("Register Status:" +registerStatus);			
			}

			// delete the record from registration
			String studentUnregister = "DELETE FROM Registrations WHERE id='" + student +"' AND code='"+ course +"'";
			int linesChanged = myStmt.executeUpdate(studentUnregister);
			if (linesChanged ==0){ 
				System.out.println("ERROR: Student is not registered or waited in this course!");
			}
			// the record do exist
			if (linesChanged > 0){
				// if registered
				if(registerStatus.equals(reg)){
					System.out.println("The student "+ student +" is successfully unregistered from the course "+ course +"!");
				}
				//if waited
				if(registerStatus.equals(wait)){
					System.out.println("The student "+ student +" is successfully removed from the course "+ course +" waitinglist !");					
				}
			}// end of if record exist
		}// end of try
		catch(SQLException e){
			String errorMessage = e.getMessage();
			System.out.println(errorMessage);
		}
	}
}