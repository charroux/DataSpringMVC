package org.oLabDynamics.thematicSite.web;

import java.util.List;

import org.oLabDynamics.client.Author;
import org.oLabDynamics.client.CompanionSite;
import org.oLabDynamics.client.ExecShare;
import org.oLabDynamics.client.Publication;
import org.oLabDynamics.client.Query;
import org.oLabDynamics.client.ThematicSite;
import org.oLabDynamics.client.write.CompanionSiteReadWrite;
import org.oLabDynamics.client.write.PublicationReadWrite;
import org.oLabDynamics.client.write.ThematicSiteReadWrite;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ThematicSiteController {
	
	ThematicSiteReadWrite thematicSite = new ThematicSiteReadWrite();
	
/*	public ThematicSiteController(){
		ExecShare execShare = ExecShare.getInstance();
		
		try{
			Query query = new Query("author");
			query.addFilter("name", Query.FilterOperator.EQUAL, "Tintin");
			List<Author> authors = execShare.prepare(query);
			Author author = authors.get(0);
			System.out.println(author);
		}catch(Exception e){
			e.printStackTrace();
		}

	}*/
	
/*	@RequestMapping(value="/*", method=RequestMethod.GET)
	public void getAll(){
		System.out.println("ok");
	}*/
	
	@RequestMapping(value="/thematicSite", method=RequestMethod.GET)
	public ModelAndView get(){
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("newThematicSite");
		return modelAndView;
	}
	
	@RequestMapping(value="/thematicSite", method=RequestMethod.PUT)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	public String put(@RequestBody PublicationReadWrite publication){
		CompanionSite companionSite = publication.getCompanionSite();
		thematicSite.addCompanionSite(companionSite);
		System.out.println(thematicSite);
		return "ok";
	}
	
}
