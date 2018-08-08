/*

Developed with the contribution of the European Commission - Directorate General for Maritime Affairs and Fisheries
© European Union, 2017.

This file is part of the Integrated Fisheries Data Management (IFDM) Suite. The IFDM Suite is free software: you can
redistribute it and/or modify it under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or any later version. The IFDM Suite is distributed in
the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details. You should have received a
copy of the GNU General Public License along with the IFDM Suite. If not, see <http://www.gnu.org/licenses/>.

*/
package eu.europa.ec.fisheries.uvms.docker.validation;

import org.apache.http.HttpStatus;
import org.apache.http.client.fluent.Request;
import org.junit.Test;

import eu.europa.ec.fisheries.uvms.docker.validation.common.AbstractRest;

/**
 * The Class ModuleAvailableSystemIT.
 */
public class ModuleAvailableSystemIT extends AbstractRest {

	/**
	 * Check user access test.
	 *
	 * @throws Exception
	 *             the exception
	 */
	@Test
	public void checkUserAccessTest() throws Exception {
		assertEquals(HttpStatus.SC_OK, Request.Get(getBaseUrl() + "usm-administration/").execute().returnResponse()
				.getStatusLine().getStatusCode());
		assertEquals(HttpStatus.SC_OK, Request.Get(getBaseUrl() + "user/monitoring").execute().returnResponse()
				.getStatusLine().getStatusCode());		
		assertEquals(HttpStatus.SC_FORBIDDEN, Request.Get(getBaseUrl() + "/usm-administration/rest").execute()
				.returnResponse().getStatusLine().getStatusCode());
	}

	/**
	 * Check config access test.
	 *
	 * @throws Exception
	 *             the exception
	 */
	@Test
	public void checkConfigAccessTest() throws Exception {
		assertEquals(HttpStatus.SC_OK,
				Request.Get(getBaseUrl() + "config/").execute().returnResponse().getStatusLine().getStatusCode());
		assertEquals(HttpStatus.SC_OK,
				Request.Get(getBaseUrl() + "config/monitoring").execute().returnResponse().getStatusLine().getStatusCode());		
		assertEquals(HttpStatus.SC_FORBIDDEN,
				Request.Get(getBaseUrl() + "config/rest").execute().returnResponse().getStatusLine().getStatusCode());
	}

	/**
	 * Check exchange access test.
	 *
	 * @throws Exception
	 *             the exception
	 */
	@Test
	public void checkExchangeAccessTest() throws Exception {
		assertEquals(HttpStatus.SC_FORBIDDEN,
				Request.Get(getBaseUrl() + "exchange/").execute().returnResponse().getStatusLine().getStatusCode());
		assertEquals(HttpStatus.SC_OK,
				Request.Get(getBaseUrl() + "exchange/monitoring").execute().returnResponse().getStatusLine().getStatusCode());		
		assertEquals(HttpStatus.SC_FORBIDDEN,
				Request.Get(getBaseUrl() + "exchange/rest").execute().returnResponse().getStatusLine().getStatusCode());
	}

	/**
	 * Check spatial access test.
	 *
	 * @throws Exception
	 *             the exception
	 */
	@Test
	public void checkSpatialAccessTest() throws Exception {
		assertEquals(HttpStatus.SC_FORBIDDEN,
				Request.Get(getBaseUrl() + "spatial/").execute().returnResponse().getStatusLine().getStatusCode());
		assertEquals(HttpStatus.SC_OK,
				Request.Get(getBaseUrl() + "spatial/monitoring").execute().returnResponse().getStatusLine().getStatusCode());		
		assertEquals(HttpStatus.SC_FORBIDDEN,
				Request.Get(getBaseUrl() + "spatial/rest").execute().returnResponse().getStatusLine().getStatusCode());
	}

	/**
	 * Check movement access test.
	 *
	 * @throws Exception
	 *             the exception
	 */
	@Test
	public void checkMovementAccessTest() throws Exception {
		assertEquals(HttpStatus.SC_FORBIDDEN,
				Request.Get(getBaseUrl() + "movement/").execute().returnResponse().getStatusLine().getStatusCode());
		assertEquals(HttpStatus.SC_OK,
				Request.Get(getBaseUrl() + "movement/monitoring").execute().returnResponse().getStatusLine().getStatusCode());		
		assertEquals(HttpStatus.SC_FORBIDDEN,
				Request.Get(getBaseUrl() + "movement/rest").execute().returnResponse().getStatusLine().getStatusCode());
		assertEquals(HttpStatus.SC_OK, Request.Get(getBaseUrl() + "movement/monitoring").execute().returnResponse()
				.getStatusLine().getStatusCode());
	}

	/**
	 * Check audit access test.
	 *
	 * @throws Exception
	 *             the exception
	 */
	@Test
	public void checkAuditAccessTest() throws Exception {
		assertEquals(HttpStatus.SC_OK,
				Request.Get(getBaseUrl() + "audit/").execute().returnResponse().getStatusLine().getStatusCode());
		assertEquals(HttpStatus.SC_OK,
				Request.Get(getBaseUrl() + "audit/monitoring").execute().returnResponse().getStatusLine().getStatusCode());
		assertEquals(HttpStatus.SC_FORBIDDEN,
				Request.Get(getBaseUrl() + "audit/rest").execute().returnResponse().getStatusLine().getStatusCode());
	}

	/**
	 * Check asset access test.
	 *
	 * @throws Exception
	 *             the exception
	 */
	@Test
	public void checkAssetAccessTest() throws Exception {
		assertEquals(HttpStatus.SC_OK,
				Request.Get(getBaseUrl() + "asset/").execute().returnResponse().getStatusLine().getStatusCode());
		assertEquals(HttpStatus.SC_OK,
				Request.Get(getBaseUrl() + "asset/monitoring").execute().returnResponse().getStatusLine().getStatusCode());		
		assertEquals(HttpStatus.SC_FORBIDDEN,
				Request.Get(getBaseUrl() + "asset/rest/config").execute().returnResponse().getStatusLine().getStatusCode());
		assertEquals(HttpStatus.SC_FORBIDDEN,
                Request.Get(getBaseUrl() + "asset/rest/asset").execute().returnResponse().getStatusLine().getStatusCode());
		assertEquals(HttpStatus.SC_FORBIDDEN,
                Request.Get(getBaseUrl() + "asset/rest/group").execute().returnResponse().getStatusLine().getStatusCode());
	}

	/**
	 * Check mobileterminal access test.
	 *
	 * @throws Exception
	 *             the exception
	 */
	@Test
	public void checkMobileterminalAccessTest() throws Exception {
		assertEquals(HttpStatus.SC_FORBIDDEN,
				Request.Get(getBaseUrl() + "mobileterminal/").execute().returnResponse().getStatusLine().getStatusCode());
		assertEquals(HttpStatus.SC_FORBIDDEN, Request.Get(getBaseUrl() + "mobileterminal/rest").execute().returnResponse()
				.getStatusLine().getStatusCode());
		assertEquals(HttpStatus.SC_OK, Request.Get(getBaseUrl() + "mobileterminal/monitoring").execute().returnResponse()
				.getStatusLine().getStatusCode());

	}

	/**
	 * Check mapfish print access test.
	 *
	 * @throws Exception the exception
	 */
	@Test
	public void checkMapfishPrintAccessTest() throws Exception {
		assertEquals(HttpStatus.SC_FORBIDDEN,
				Request.Get("http://localhost:28080/" + "mapfish-print/").execute().returnResponse().getStatusLine().getStatusCode());
	}

}
