package com.amazonaws.labs.sampleapp; 
 
 
import org.springframework.context.annotation.Bean; 
import org.springframework.context.annotation.ComponentScan; 
import org.springframework.context.annotation.Configuration; 
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer; 
import org.springframework.core.io.support.PathMatchingResourcePatternResolver; 
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer; 
import org.springframework.web.servlet.config.annotation.EnableWebMvc; 
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry; 
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter; 
import org.springframework.web.servlet.view.InternalResourceViewResolver; 
 
import com.amazonaws.regions.Region; 
import com.amazonaws.regions.Regions; 
import com.amazonaws.services.autoscaling.AmazonAutoScaling; 
import com.amazonaws.services.autoscaling.AmazonAutoScalingClient; 
import com.amazonaws.services.codedeploy.AmazonCodeDeploy; 
import com.amazonaws.services.codedeploy.AmazonCodeDeployClient; 
import com.amazonaws.services.ec2.AmazonEC2; 
import com.amazonaws.services.ec2.AmazonEC2Client; 
 
import java.io.File; 
import java.util.Properties; 
 
import java.io.IOException; 
 
@EnableWebMvc 
@ComponentScan(basePackages = {"com.amazonaws.labs.sampleapp"}) 
@Configuration 
public class MvcConfiguration extends WebMvcConfigurerAdapter { 
    private static Region region = Regions.getCurrentRegion(); 
 
    @Override 
    public void addResourceHandlers(final ResourceHandlerRegistry registry) { 
        registry.addResourceHandler("/css/**").addResourceLocations("classpath:/css/"); 
        registry.addResourceHandler("/images/**").addResourceLocations("classpath:/images/"); 
        registry.addResourceHandler("/webjars/**").addResourceLocations("classpath:/META-INF/resources/webjars/"); 
    } 
 
    @Override 
    public void configureDefaultServletHandling(final DefaultServletHandlerConfigurer configurer) { 
        configurer.enable(); 
    } 
 
    @Bean 
    public InternalResourceViewResolver viewResolver() { 
        InternalResourceViewResolver resolver = new InternalResourceViewResolver(); 
        resolver.setPrefix("/WEB-INF/pages"); 
        resolver.setSuffix(".jsp"); 
        return resolver; 
    } 
 
    @Bean 
    public AmazonCodeDeploy codeDeploy() { 
        final AmazonCodeDeploy client = new AmazonCodeDeployClient(); 
        if ( region == null ) 
            region = Region.getRegion(Regions.fromName("us-west-2")); 
        client.setRegion(region); 
        return client; 
    } 
 
    @Bean 
    public AmazonEC2 ec2() { 
        final AmazonEC2 client = new AmazonEC2Client(); 
        if ( region == null ) 
            region = Region.getRegion(Regions.fromName("us-west-2")); 
        client.setRegion(region); 
        return client; 
    } 
 
    @Bean 
    public AmazonAutoScaling autoScaling() { 
        AmazonAutoScaling client = new AmazonAutoScalingClient(); 
        if ( region == null ) 
            region = Region.getRegion(Regions.fromName("us-west-2")); 
        client.setRegion(region); 
        return client; 
    } 
 
    @Bean 
    public PropertySourcesPlaceholderConfigurer properties() { 
        final PropertySourcesPlaceholderConfigurer configurer = new PropertySourcesPlaceholderConfigurer(); 
        try { 
 
            File f = new File("/etc/elasticbeanstalk/.aws-eb-stack.properties"); 
            File docf = new File("/var/docker/tomcat-sample/env.properties"); 
            if(f.exists()) 
            { 
              System.out.println("This is ElasticBeanStalk environment"); 
              Properties props = new Properties(); 
              props.setProperty("APPLICATION_NAME","EB-Demo-Web-App"); 
              props.setProperty("DEPLOYMENT_GROUP_NAME","ElasticBeanStalk"); 
              configurer.setProperties(props); 
            } 
            else if(docf.exists()) 
            { 
              System.out.println("This is docker based environment"); 
              Properties props = new Properties(); 
              props.setProperty("APPLICATION_NAME","Docker-Demo-Web-App"); 
              props.setProperty("DEPLOYMENT_GROUP_NAME","ContainerDeployment"); 
              configurer.setProperties(props); 
            } 
            else 
            { 
              configurer.setLocations(new PathMatchingResourcePatternResolver().getResources("file:/var/codedeploy/tomcat-sample/env.properties")); 
            } 
        } catch (Exception e) { 
            //throw new RuntimeException("Failed to load resources.", e); 
        } 
        return configurer; 
    } 
} 
 