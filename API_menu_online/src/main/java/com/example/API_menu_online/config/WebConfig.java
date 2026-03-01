package com.example.API_menu_online.config;

import com.example.API_menu_online.interceptor.AuthInterceptor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;
import java.io.File;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = "com.example.API_menu_online.controller")
@PropertySource("classpath:application.properties")
public class WebConfig implements WebMvcConfigurer {

    private static final Logger logger = LoggerFactory.getLogger(WebConfig.class);

    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        System.out.println("=== addResourceHandlers CALLED ===");

        try {
            // Thử tìm từ nhiều vị trí
            String[] possiblePaths = {
                    "D:\\API_menu_online\\API_menu_online\\uploads",  // Đường dẫn project thực tế
//                    "D:\\API_menu_online\\uploads\\", // Windows path với backslash
                    System.getProperty("user.dir") + "/uploads/",
                    System.getProperty("user.dir") + "/../../../uploads/", // Lên 3 cấp từ SmartTomcat
                    System.getProperty("user.home") + "/API_menu_online/uploads/"
            };

            String uploadPath = null;
            for (String path : possiblePaths) {
                File dir = new File(path);
                System.out.println("Checking path: " + path + " - Exists: " + dir.exists());
                if (dir.exists() && dir.isDirectory()) {
                    uploadPath = path;
                    System.out.println("✓ Found uploads at: " + path);
                    break;
                }
            }

            // Fallback
            if (uploadPath == null) {uploadPath = "D:\\API_menu_online\\API_menu_online\\uploads";
                System.out.println("⚠ Using fallback: " + uploadPath);
            }

            // Chuẩn hóa đường dẫn
            uploadPath = uploadPath.replace("\\", "/");
            if (!uploadPath.endsWith("/")) {
                uploadPath += "/";
            }

            String fileUrl = "file:///" + uploadPath;

            System.out.println("=== UPLOAD RESOURCE HANDLER ===");
            System.out.println("Upload path: " + uploadPath);
            System.out.println("File URL: " + fileUrl);

            File uploadDirectory = new File(uploadPath);
            System.out.println("Directory exists: " + uploadDirectory.exists());
            System.out.println("Directory absolute path: " + uploadDirectory.getAbsolutePath());

            if (uploadDirectory.exists()) {
                String[] files = uploadDirectory.list();
                System.out.println("Files count: " + (files != null ? files.length : 0));
                if (files != null && files.length > 0) {
                    System.out.println("First 5 files: " + java.util.Arrays.toString(
                            java.util.Arrays.copyOf(files, Math.min(5, files.length))));
                }
            } else {
                System.err.println("⚠ WARNING: Upload directory does not exist!");
            }
            System.out.println("==============================");

            // Map resource handlers
            registry.addResourceHandler("/uploads/**")
                    .addResourceLocations(fileUrl)
                    .setCachePeriod(3600);

            registry.addResourceHandler("/API_menu_online/uploads/**")
                    .addResourceLocations(fileUrl)
                    .setCachePeriod(3600);

        } catch (Exception e) {
            System.err.println("ERROR configuring upload handler: " + e.getMessage());
            e.printStackTrace();
        }

        // Phục vụ tài nguyên tĩnh từ classpath
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/")
                .setCachePeriod(3600);
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/")
                .setCachePeriod(3600);
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/")
                .setCachePeriod(3600);
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("classpath:/resources/")
                .setCachePeriod(3600);
    }

    @Bean
    public ViewResolver viewResolver() {
        InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
        viewResolver.setViewClass(JstlView.class);
        viewResolver.setPrefix("/WEB-INF/views/");
        viewResolver.setSuffix(".jsp");
        viewResolver.setContentType("text/html;charset=UTF-8");
        return viewResolver;
    }@Bean
    public StandardServletMultipartResolver multipartResolver() {
        return new StandardServletMultipartResolver();
    }

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }

    @Bean
    public CharacterEncodingFilter characterEncodingFilter() {
        CharacterEncodingFilter filter = new CharacterEncodingFilter();
        filter.setEncoding("UTF-8");
        filter.setForceEncoding(true);
        filter.setForceRequestEncoding(true);
        filter.setForceResponseEncoding(true);
        return filter;
    }

    @Override
    public void configureMessageConverters(java.util.List<HttpMessageConverter<?>> converters) {
        StringHttpMessageConverter stringConverter = new StringHttpMessageConverter(
                java.nio.charset.StandardCharsets.UTF_8);
        converters.add(stringConverter);

        ByteArrayHttpMessageConverter byteArrayConverter = new ByteArrayHttpMessageConverter();
        converters.add(byteArrayConverter);

        try {
            org.springframework.http.converter.json.MappingJackson2HttpMessageConverter jsonConverter =
                    new org.springframework.http.converter.json.MappingJackson2HttpMessageConverter();
            java.util.List<org.springframework.http.MediaType> mediaTypes = new java.util.ArrayList<>();
            mediaTypes.add(org.springframework.http.MediaType.APPLICATION_JSON);
            jsonConverter.setSupportedMediaTypes(mediaTypes);
            converters.add(jsonConverter);
        } catch (NoClassDefFoundError e) {
            logger.warn("Không tìm thấy Jackson", e);
        } catch (Exception e) {
            logger.warn("Không thể thêm Jackson JSON converter: {}", e.getMessage(), e);
        }
    }

    @Bean
    public AuthInterceptor authInterceptor() {
        return new AuthInterceptor();
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/login",
                        "/login/**",
                        "/register",
                        "/register/**",
                        "/restaurant/*/menu",
                        "/restaurant/token/*/menu",
                        "/restaurant/*/qr",
                        "/API_menu_online/uploads/**",
                        "/uploads/**",
                        "/css/**",
                        "/js/**",
                        "/images/**",
                        "/resources/**",
                        "/api/**",
                        "/orders/create",
                        "/"
                );
    }
}
