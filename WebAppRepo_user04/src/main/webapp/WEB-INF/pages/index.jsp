<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="java.util.List" %> 
<%@ page import="java.util.Map" %> 
 
<% 
    /* 
     * ELB checks your application's health by periodically 
     * sending an HTTP HEAD request to a resource in your application. By 
     * default, this is the root or default resource in your application, 
     * but can be configured for each environment. 
     * 
     * Here, we report success as long as the app server is up, but skip 
     * generating the whole page since this is a HEAD request only. You 
     * can employ more sophisticated health checks in your application. 
     */ 
    if (request.getMethod().equals("HEAD")) return; 
%> 
 
<!DOCTYPE html> 
<html> 
<head> 
    <meta http-equiv="Content-type" content="text/html; charset=utf-8"> 
    <title> A sample web app</title> 
    <meta name="viewport" content="initial-scale=1.0"> 
    <link rel='stylesheet' href='webjars/bootstrap/3.2.0/css/bootstrap.min.css'> 
    <link rel='stylesheet' href='webjars/bootstrap/3.2.0/css/bootstrap-theme.min.css'> 
    <link rel='stylesheet' href='css/theme.css'> 
</head> 
<body role="document"> 
  <div class="container theme-showcase" role="main"> 
    <div class="jumbotron"> 
      <h1>A Sample web application: Demo</h1> 
      <p><i>Why can't application deployment be sooooooooooooooo easy?</i></p> 
    </div> 
    <div class="page-header"> 
      <h1>Our Products</h1> 
    </div> 
    <div class="panel panel-default" > 
      <div class="row"> 
        <div class="col-sm-9 col-md-9 col-lg-9"> 
          <div class="panel panel-default"> 
            <div class="panel-heading"> 
              <h3 class="panel-title">AWS CodeCommit</h3> 
            </div> 
            <div class="panel-body"> 
              AWS CodeBuild is a fully managed build service that compiles source code, runs tests, and produces software packages that are ready to deploy. With CodeBuild, you don’t need to provision, manage, and scale your own build servers. CodeBuild scales continuously and processes multiple builds concurrently, so your builds are not left waiting in a queue. 
              <a href="https://aws.amazon.com/codebuild/" target="_blank" >More info</a> 
            </div> 
          </div> 
        </div> 
        <div class="col-sm-2 col-md-2 col-lg-2"> 
          <div class="panel panel-default"> 
            <div class="panel-body"> 
              <img src="images/codecommit.png" style="width:100px;height:100px;"> 
            </div> 
          </div> 
        </div> 
      </div> 
      <div class="row"> 
        <div class="col-sm-2 col-md-2 col-lg-2"> 
          <div class="panel panel-default"> 
            <div class="panel-body"> 
              <img src="images/codebuild.png" style="width:100px;height:100px;"> 
            </div> 
          </div> 
        </div> 
        <div class="col-sm-9 col-md-9 col-lg-9"> 
          <div class="panel panel-default"> 
            <div class="panel-heading"> 
              <h3 class="panel-title">AWS CodeBuild</h3> 
            </div> 
            <div class="panel-body"> 
              AWS CodePipeline is a continuous delivery service for fast and reliable application updates. CodePipeline builds, tests, and deploys your code every time there is a code change, based on the release process models you define. 
              <a href="https://aws.amazon.com/codepipeline/" target="_blank" >More info</a> 
            </div> 
          </div> 
        </div> 
      </div> 
      <div class="row"> 
        <div class="col-sm-9 col-md-9 col-lg-9"> 
          <div class="panel panel-default"> 
            <div class="panel-heading"> 
              <h3 class="panel-title">AWS Codepipeline</h3> 
            </div> 
            <div class="panel-body"> 
              AWS CodePipeline is a continuous delivery service for fast and reliable application updates. CodePipeline builds, tests, and deploys your code every time there is a code change, based on the release process models you define. 
              <a href="https://aws.amazon.com/codepipeline/" target="_blank" >More info</a> 
            </div> 
          </div> 
        </div> 
        <div class="col-sm-2 col-md-2 col-lg-2"> 
          <div class="panel panel-default"> 
            <div class="panel-body"> 
              <img src="images/codepipe.png" style="width:100px;height:100px;"> 
            </div> 
          </div> 
        </div> 
      </div> 
      <div class="row"> 
        <div class="col-sm-2 col-md-2 col-lg-2"> 
          <div class="panel panel-default"> 
            <div class="panel-body"> 
              <img src="images/codedeploy.png" style="width:100px;height:100px;"> 
            </div> 
          </div> 
        </div> 
        <div class="col-sm-9 col-md-9 col-lg-9"> 
          <div class="panel panel-default"> 
            <div class="panel-heading"> 
              <h3 class="panel-title">AWS CodeDeploy</h3> 
            </div> 
            <div class="panel-body"> 
              AWS CodeDeploy is a service that automates code deployments to any instance, including Amazon EC2 instances and instances running on-premises. 
              <a href="https://aws.amazon.com/codedeploy/" target="_blank" >More info</a> 
            </div> 
          </div> 
        </div> 
      </div> 
      <% if (!(((String) request.getAttribute("deploymentGroupName")).contains("ContainerDeployment") || ((String) request.getAttribute("deploymentGroupName")).contains("ElasticBeanStalk"))) { %> 
        <div class="alert alert-info" role="alert"> 
          <p><strong>AWS CodeDeploy Application:</strong> ${applicationName}</p> 
          <p><strong>AWS CodeDeploy Deployment Group:</strong> ${deploymentGroupName}</p> 
          <strong>Amazon EC2 Instances associated with this fleet:</strong> 
          <ul> 
            <% for (final String instance : (List<String>) request.getAttribute("instanceIds")) { %> 
              <% if (((Map<String, String>) request.getAttribute("instanceStates")).containsKey(instance)) { %> 
                <li> <%= instance %> - Instance Health: <%= ((Map<String, String>) request.getAttribute("instanceStates")).get(instance) %></li> 
              <% } else { %> 
                <li> <%= instance %> - Instance Health: Unknown</li> 
              <% } %> 
            <% } %> 
          </ul> 
        </div> 
      <% } %> 
        <% if (((String) request.getAttribute("deploymentGroupName")).contains("Prod")) { %> 
          <div class="alert alert-dismissible alert-warning"> 
            <button type="button" class="close" data-dismiss="alert">×</button> 
            <h1>Alert!</h1> 
            <p>You are viewing <b>Production</b> version of this application</p> 
          </div> 
        <% } %> 
        <% if (((String) request.getAttribute("deploymentGroupName")).contains("ElasticBeanStalk")) { %> 
          <div class="alert alert-dismissible alert-warning"> 
            <button type="button" class="close" data-dismiss="alert">×</button> 
            <h1>Alert!</h1> 
            <p>You are viewing version of this application deployed from ElasticBeanstalk Environment.</p> 
          </div> 
        <% } %> 
        <% if (((String) request.getAttribute("deploymentGroupName")).contains("ContainerDeployment")) { %> 
          <div class="alert alert-dismissible alert-warning"> 
            <button type="button" class="close" data-dismiss="alert">×</button> 
            <h1>Alert!</h1> 
            <p>You are viewing version of this application deployed from Container based deployment Environment.</p> 
          </div> 
        <% } %>         
    </div> 
  </div> 
  <script type="text/javascript" src="webjars/jquery/2.1.1/jquery.min.js"></script> 
  <script type="text/javascript" src="webjars/bootstrap/3.2.0/js/bootstrap.min.js"></script> 
</body> 
</html> 
 