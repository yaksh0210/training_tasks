# Project 

## Comprehensive AWS S3 Management and Static Website Hosting

### Objective:

+ To test your knowledge and skills in managing AWS S3 storage classes, lifecycle management, bucket policies, access control lists (ACLs), and hosting a static website on S3. You will apply their understanding in a practical scenario, ensuring you have mastered the critical aspects of AWS S3.

## Project Scenario:

+ You are tasked with creating and managing an S3 bucket for a fictional company, "TechVista Inc.," that hosts a static website for displaying their product portfolio. The website will have different types of content, including high-resolution images, which require careful storage management to optimize costs. Additionally, the company has strict security requirements for accessing the content.

## Project Steps and Deliverables:

### **1. Create and Configure an S3 Bucket:**


+ Create an S3 bucket named techvista-portfolio-[your-initials].

+ Enable versioning on the bucket.


## Output 

<img src="./images/pic1.png">
<br>

<img src="./images/pic2.png">
<br>

<img src="./images/pic3.png">
<br>

+ Set up the bucket for static website hosting.

<img src="./images/pic4.png">
<br>

+ Upload the provided static website files (HTML, CSS, images).

<img src="./images/pic5.png">
<br>


+ Ensure the website is accessible via the S3 website URL.

<br>
<img src="./images/pic6.png">
<br>

<br>
<img src="./images/pic7.png">
<br>

<hr>

### **2.Implement S3 Storage Classes:**

+ Classify the uploaded content into different S3 storage classes (e.g., Standard, Intelligent-Tiering, Glacier).

+ Justify your choice of storage class for each type of content (e.g., HTML/CSS files vs. images).

<br>
<img src="./images/pic9.png">
<br>

<br>
<img src="./images/pic8.png">
<br>


### **3.Lifecycle Management:**

+ Create a lifecycle policy that transitions older versions of objects to a more cost-effective storage class (e.g., Standard to Glacier).


<br>
<img src="./images/pic10.png">
<br>

<br>
<img src="./images/pic11.png">
<br>


+ Set up a policy to delete non-current versions of objects after 90 days.

<img src="./images/pic12.png">
<br>

+ Verify that the lifecycle rules are correctly applied.

<img src="./images/pic14.png">
<br>

### **4.Configure Bucket Policies and ACLs:**

+ Create and attach a bucket policy that allows read access to everyone for the static website content.

+ Restrict access to the S3 management console for specific IAM users using the bucket policy.


<img src="./images/pic15.png">
<br>
